import 'package:flutter/material.dart';
import '../screens/profile.dart';
import '../screens/homePage.dart';
import '../screens/settings.dart';
import '../screens/messages.dart';

class CustomBottomAppBar extends StatefulWidget {
  final int currentIndex;
  const CustomBottomAppBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _navigateTo(context, const HomePage(), index);
        break;
      case 1:
        _navigateTo(context, const MessagesPage(), index);
        break;
      case 2:
        _navigateTo(context, const ProfilePage(), index);
        break;
      case 3:
        _navigateTo(context, const SettingsPage(), index);
        break;
    }
  }

  void _navigateTo(BuildContext context, Widget page, int index) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    ).then((_) {
      setState(() {
        _selectedIndex = index;
      });
    });
  }

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
        color: const Color(0xFFB7425B),
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildIconButton(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                index: 0,
              ),
              _buildIconButton(
                icon: Icons.chat_outlined,
                selectedIcon: Icons.chat,
                index: 1,
              ),
              _buildIconButton(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                index: 2,
              ),
              _buildIconButton(
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required IconData selectedIcon,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return IconButton(
      icon: CircleAvatar(
        radius: 30, // You can adjust the radius as needed
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        child: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected
              ? const Color.fromARGB(255, 183, 66, 91)
              : Colors.white,
          size: 30,
        ),
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}