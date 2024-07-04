import 'package:flutter/material.dart';
import 'navbar.dart'; 
import 'changePassword.dart';
import'aboutUs.dart';
import 'loginScreen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  Future<void> _updatePushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('pushNotifications', value);
    setState(() {
      _pushNotifications = value;
    });
  }

  Future<void> _updateBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometricEnabled', value);
    setState(() {
      _biometricEnabled = value;
    });
  }

  Route createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  createFadeRoute(const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 120), // Add spacing at the top
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img2.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Jhon Abraham',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          ListTile(
            title: const Text('Change password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change password action
              Navigator.of(context).push(createFadeRoute(const ChangePasswordPage()));
            },
          ),
          SwitchListTile(
            title: const Text('Push notifications'),
            value: _pushNotifications,
            activeColor: const Color.fromARGB(255, 183, 66, 91),
            onChanged: (bool value) {
              _updatePushNotifications(value); // Call _updatePushNotifications
            },
          ),
          SwitchListTile(
            title: const Text('Enable biometric'),
            value: _biometricEnabled,
            activeColor: const Color.fromARGB(255, 183, 66, 91),
            onChanged: (bool value) {
              _updateBiometricEnabled(value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle about us action
              Navigator.of(context).push(createFadeRoute( AboutUsPage()));
            },
          ),
          ListTile(
            title: const Text('Terms and conditions'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle privacy policy action
            },
          ),
          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showLogoutConfirmationDialog,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
