import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled3/screens/homePage.dart';
import 'package:http/http.dart' as http;
import 'loginScreen.dart';

class InterestsPage extends StatefulWidget {
  final int? userId;
  const InterestsPage({Key? key, required this.userId}) : super(key: key);

  @override
  InterestsPageState createState() => InterestsPageState();
}

class InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  bool canContinue() {
    return selectedInterests.isNotEmpty;
  }

  Future<void> submitInterests() async {
    final interestMap = {
      'Photography': 1,
      'Shopping': 2,
      'Karaoke': 3,
      'Yoga': 4,
      'Cooking': 5,
      'Tennis': 6,
      'Run': 7,
      'Swimming': 8,
      'Art': 9,
      'Traveling': 10,
      'Extreme': 11,
      'Music': 12,
      'Drink': 13,
      'Video games': 14
    };

    final List<int> interestIds =
        selectedInterests.map((interest) => interestMap[interest]!).toList();

    for (int interestId in interestIds) {
      final payload = {
        'userId': widget.userId,
        'interestId': interestId, // Send single interestId
      };

      print('Payload: $payload'); // Print the payload for debugging

      try {
        final response = await http.post(
          Uri.parse('http://16.171.150.101/N.A.C.K/backend/users/interests'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload), // Send single object
        );

        if (response.statusCode != 200) {
          // Log error details if one of the requests fails
          print(
              'Failed to submit interestId $interestId: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit interests')),
          );
          return;
        }
      } catch (e) {
        // Log exception details if one of the requests fails
        print('Exception occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
        );
        return;
      }
    }

    // If all requests succeed, navigate to the HomePage
    Navigator.push(
      context,
      _createRoute(const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 183, 66, 91), // Match AppBar color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 66, 91),
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button

        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                _createRoute(const LoginScreen()),
              );
            },
            child: const Text(
              "",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your interests",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Select a few of your interests and let everyone know what you're passionate about.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interests.map((interest) {
                        bool isSelected =
                            selectedInterests.contains(interest['name']);
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(interest['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : const Color.fromARGB(255, 183, 66, 91)),
                              const SizedBox(width: 8),
                              Text(interest['name']),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            toggleInterest(interest['name']);
                          },
                          selectedColor: const Color.fromARGB(255, 183, 66, 91),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 183, 66, 91)),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: canContinue()
                            ? () {
                                submitInterests();
                              }
                            : null, // Disable button if no interests selected
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 183, 66, 91),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

final List<Map<String, dynamic>> interests = [
  {'name': 'Photography', 'icon': Icons.camera_alt},
  {'name': 'Shopping', 'icon': Icons.shopping_bag},
  {'name': 'Karaoke', 'icon': Icons.mic},
  {'name': 'Yoga', 'icon': Icons.self_improvement},
  {'name': 'Cooking', 'icon': Icons.restaurant},
  {'name': 'Tennis', 'icon': Icons.sports_tennis},
  {'name': 'Run', 'icon': Icons.directions_run},
  {'name': 'Swimming', 'icon': Icons.pool},
  {'name': 'Art', 'icon': Icons.brush},
  {'name': 'Traveling', 'icon': Icons.terrain},
  {'name': 'Extreme', 'icon': Icons.directions_bike},
  {'name': 'Music', 'icon': Icons.music_note},
  {'name': 'Drink', 'icon': Icons.local_bar},
  {'name': 'Video games', 'icon': Icons.videogame_asset},
];
