import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/screens/profile.dart';
import '../models/other_user.dart';
import '../providers/user_provider.dart';
import '../widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'match.dart'; // Import MatchPage
import '../providers/auth_provider.dart'; // Import AuthProvider

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseProfileDir =
      'http://16.171.150.101/N.A.C.K/backend/public/profile_images/';
  List<OtherUser> _profiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
  }

  void _fetchUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchAllUsers();

    setState(() {
      _profiles = userProvider.users;
    });
  }

  void _assignUsers() {}

  void _nextProfile() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _profiles.length;
    });
  }

  // Like a user feature
  void _likeUser(int userId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.userId;

    if (currentUserId == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    final url = Uri.parse(
        'http://16.171.150.101/N.A.C.K/backend/users/like'); // Update with your endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'liked_userId': userId,
          'userId': currentUserId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["message"] == "Match has been created") {
          _goToMatchPage();
        } else {
          _nextProfile();
        }

        print('User liked successfully');
      } else {
        print('Failed to like user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _goToMatchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchPage()),
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
=======
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final currentProfile = _profiles[_currentIndex];
    final authProvider =
        Provider.of<AuthProvider>(context); // Access AuthProvider
    final userProfileImage =
        '$baseProfileDir${authProvider.user?.profileImage ?? 'default_user.png'}'; // Get user's profile picture or default
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(6.5),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userProfileImage),
              radius: 5,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              _createRoute(const ProfilePage()),
            );
          },
        ),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              // Action for notifications
            },
          ),
        ],
      ),
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        '$baseProfileDir${_profiles[_currentIndex].profileImage}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 150,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.black, size: 30),
                                  onPressed: _nextProfile,
                                ),
                              ),
                              const SizedBox(width: 30),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    const Color.fromARGB(255, 183, 66, 91),
                                child: IconButton(
                                  icon: const Icon(Icons.favorite,
                                      color: Colors.white, size: 30),
                                  onPressed: () => _likeUser(_profiles[_currentIndex].userId),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${_profiles[_currentIndex].firstName} ${_profiles[_currentIndex].lastName}, ${12}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // const Icon(Icons.location_on,
                              //     color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                _profiles[_currentIndex].userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _profiles[_currentIndex].bio,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: const ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: CustomBottomAppBar(),
      ),
    );
  }
}
