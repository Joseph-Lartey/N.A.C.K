import 'package:flutter/material.dart';
import 'package:untitled3/messages.dart';
import 'profile.dart';
import 'homePage.dart';
//import 'settings.dart';

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
        color: const Color.fromARGB(255, 183, 66, 91),
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
                      _navigateTo(context, HomePage(), currentIndex: 0);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, Messages(), currentIndex: 1);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _navigateTo(context, ProfilePage(), currentIndex: 2);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      //_navigateTo(context, SettingsPage(), currentIndex: 3);
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

  void _navigateTo(BuildContext context, Widget page,
      {required int currentIndex}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const Offset beginRight = Offset(1.0, 0.0);
          const Offset endRight = Offset.zero;
          const Offset beginLeft = Offset(-1.0, 0.0);
          const Offset endLeft = Offset.zero;
          const Curve curve = Curves.easeInOut;

          final Animatable<Offset> tweenRight =
              Tween(begin: beginRight, end: endRight)
                  .chain(CurveTween(curve: curve));
          final Animatable<Offset> tweenLeft =
              Tween(begin: beginLeft, end: endLeft)
                  .chain(CurveTween(curve: curve));

          final Animation<Offset> offsetAnimation =
              animation.drive(currentIndex % 2 == 0 ? tweenLeft : tweenRight);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
