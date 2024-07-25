import 'package:flutter/material.dart';
import '../screens/profile.dart';
import '../screens/homePage.dart';
import '../screens/settings.dart';
import '../screens/messages.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Color(0xFFB7425B),
        child: SizedBox(
          height: 60.0,
          child: Builder(
            builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, const HomePage());
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, const MessagesPage());
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, const ProfilePage());
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, const SettingsPage());
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
