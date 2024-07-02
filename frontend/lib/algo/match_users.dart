import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  int userId;
  String name;
  String profilePictureUrl;
  String gender;
  DateTime dob;
  String genderPreference;
  int ageRangeMin;
  int ageRangeMax;
  List<String> interests;

  User({
    required this.userId,
    required this.name,
    required this.profilePictureUrl,
    required this.gender,
    required this.dob,
    required this.genderPreference,
    required this.ageRangeMin,
    required this.ageRangeMax,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      profilePictureUrl: json['profilePictureUrl'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      genderPreference: json['gender_preference'],
      ageRangeMin: json['age_range_min'],
      ageRangeMax: json['age_range_max'],
      interests: (json['interests'] as String).split(', '),
    );
  }
}


// assuming we have the end point
Future<List<User>> fetchUsers(int userId) async {
  final response = await http.get(Uri.parse('http://yourapi.com/users'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    List<User> users = jsonData.map((data) => User.fromJson(data)).toList();
    return users;
  } else {
    throw Exception('Failed to load users');
  }
}

double calculateSimilarity(List<String> interests1, List<String> interests2) {
  final Set<String> set1 = interests1.toSet();
  final Set<String> set2 = interests2.toSet();
  final int intersection = set1.intersection(set2).length;
  final int union = set1.union(set2).length;
  return intersection / union;
}

Future<List<Map<String, dynamic>>> matchUsers(int userId) async {
  final users = await fetchUsers(userId);

  final currentUser = users.firstWhere((user) => user.userId == userId);
  final otherUsers = users.where((user) => user.userId != userId).toList();

  const double threshold = 0.3;
  final List<Map<String, dynamic>> matches = [];

  for (final user in otherUsers) {
    final double similarity = calculateSimilarity(currentUser.interests, user.interests);
    if (similarity >= threshold) {
      matches.add({
        'userId': user.userId,
        'name': user.name,
        'profilePictureUrl': user.profilePictureUrl,
        'similarity': similarity
      });
    }
  }

  return matches;
}

class MatchResults extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> matchesFuture;

  const MatchResults({super.key, required this.matchesFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches found.'));
          } else {
            final matches = snapshot.data!;
            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return ListTile(
                  leading: Image.network(match['profilePictureUrl']),
                  title: Text(match['name']),
                  subtitle: Text('Similarity: ${(match['similarity'] * 100).toStringAsFixed(1)}%'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('User Selection')),
//         body: UserSelection(),
//       ),
//     );
//   }
// }

// class UserSelection extends StatelessWidget {
//   final TextEditingController userIdController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: userIdController,
//             decoration: const InputDecoration(
//               labelText: 'Enter User ID',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               final int userId = int.tryParse(userIdController.text) ?? 0;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MatchResults(
//                     matchesFuture: matchUsers(userId),
//                   ),
//                 ),
//               );
//             },
//             child: const Text('Find Matches'),
//           ),
//         ],
//       ),
//     );
//   }
// }


// other processing goes here 