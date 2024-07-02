import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Ensure this import points to the correct location of your navbar.dart

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
            },
          ),
          ListTile(
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle privacy policy action
            },
          ),
          ListTile(
            title: const Text('Terms and conditions'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle terms and conditions action
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
