import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart';
import 'match.dart'; // Import MatchPage
import '../providers/auth_provider.dart'; // Import AuthProvider

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _profiles = [
    {
      'image': 'assets/img1.jpg',
      'name': 'Amy',
      'age': '21',
      'location': 'Dufie Annex',
      'bio':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam et lorem et massa vestibulum bibendum.',
    },
    {
      'image': 'assets/img2.jpg',
      'name': 'John',
      'age': '25',
      'location': 'Downtown',
      'bio':
          'Passionate about photography and travel. Always looking for new adventures.',
    },
    {
      'image': 'assets/img3.jpg',
      'name': 'Emma',
      'age': '23',
      'location': 'Green Park',
      'bio':
          'Love cooking, reading, and spending time with my cat. Looking for someone to share life’s moments.',
    },
    // Add more profiles here
  ];
  int _currentIndex = 0;

  void _nextProfile() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _profiles.length;
    });
  }

  void _goToMatchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = _profiles[_currentIndex];
    final authProvider =
        Provider.of<AuthProvider>(context); // Access AuthProvider
    final userProfileImage =
        'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${authProvider.user?.profileImage ?? 'default_user.png'}'; // Get user's profile picture or default

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.all(6.5),
          child: CircleAvatar(
            backgroundImage: NetworkImage(userProfileImage),
            radius: 5,
          ),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              currentProfile['image']!,
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
                      backgroundColor: const Color.fromARGB(255, 183, 66, 91),
                      child: IconButton(
                        icon: const Icon(Icons.favorite,
                            color: Colors.white, size: 30),
                        onPressed: _goToMatchPage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${currentProfile['name']}, ${currentProfile['age']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      currentProfile['location']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  currentProfile['bio']!,
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
