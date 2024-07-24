import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'homePage.dart';
import 'messages.dart';

class MatchPage extends StatefulWidget {
  final String userId1;
  final String? userId2;

  const MatchPage({
    Key? key,
    required this.userId1,
    required this.userId2,
  }) : super(key: key);
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {
  final String baseUrl =
      "http://16.171.150.101/N.A.C.K/backend/public/profile_images";

  Route createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.close, color: Color.fromARGB(255, 183, 66, 91)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/love.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Container(
                          height: 400,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage("$baseUrl/${widget.userId1}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(20, 0),
                      child: Transform.rotate(
                        angle: 0.1,
                        child: Container(
                          height: 400,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage("$baseUrl/${widget.userId1}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.favorite,
                          color: Color.fromARGB(255, 183, 66, 91), size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/match.png',
                  height: 100, // Adjust the height as needed
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle send a message press
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 15), // Adjusted padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color.fromARGB(255, 183, 66, 91),
                  ),
                  child: GestureDetector(
                    child: const Text(
                      'Send a Message',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(createFadeRoute(ChatScreen(Message(
                        name: 'Jasmine Young',
                        avatar: 'assets/img1.jpg',
                        lastMessage: 'Last night was great?',
                        time: '2 mins ago',
                        unreadCount: 3,
                      ))));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(createFadeRoute(const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color.fromARGB(255, 249, 171, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                  ),
                  child: const Text(
                    'Keep Swiping',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 183, 66, 91)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
