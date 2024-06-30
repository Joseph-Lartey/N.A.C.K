import 'package:flutter/material.dart';

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
                      // Navigate to home screen or perform action
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Navigate to chat screen or perform action
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Navigate to profile screen or perform action
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Navigate to settings screen or perform action
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
}