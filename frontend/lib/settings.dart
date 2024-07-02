import 'package:flutter/material.dart';
import 'navbar.dart'; // Ensure this import points to the correct location of your navbar.dart

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _darkMode = false;

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
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Enable biometric'),
            value: _darkMode,
            activeColor: const Color.fromARGB(255, 183, 66, 91),
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
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
