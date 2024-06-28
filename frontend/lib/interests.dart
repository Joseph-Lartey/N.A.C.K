import 'package:flutter/material.dart';
import 'otp.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 66, 91), // Match AppBar color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 66, 91),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate to the previous page
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                _createRoute(const OtpPage()),
              );
            },
            child: const Text(
              "Skip",
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
                      "Select a few of your interests and let everyone know what you\'re passionate about.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interests.map((interest) {
                        bool isSelected = selectedInterests.contains(interest['name']);
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(interest['icon'],
                                  color: isSelected ? Colors.white : const Color.fromARGB(255, 183, 66, 91)),
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
                            side: const BorderSide(color: Color.fromARGB(255, 183, 66, 91)),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: canContinue()
                            ? () {
                                Navigator.push(
                                  context,
                                  _createRoute(const OtpPage()),
                                );
                              }
                            : null, // Disable button if no interests selected
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 183, 66, 91),
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
