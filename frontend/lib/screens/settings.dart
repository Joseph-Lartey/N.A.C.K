import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/providers/auth_provider.dart';
import 'changePassword.dart';
import 'aboutUs.dart';
import '../widgets/navbar.dart';
import 'loginScreen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _biometricEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

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

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        final bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to enable biometrics',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          _updateBiometricEnabled(true);
        } else {
          setState(() {
            _biometricEnabled = false;
          });
        }
      } else {
        _showBiometricSetupDialog();
        setState(() {
          _biometricEnabled = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _biometricEnabled = false;
      });
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometrics Not Set Up'),
          content: const Text(
              'Biometric authentication is not set up on this device. Please set it up in your device settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userProfileImage =
        'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${user?.profileImage ?? 'default_user.png'}';

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 120), // Add spacing at the top
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userProfileImage),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          ListTile(
            title: const Text('Change password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change password action
              Navigator.of(context)
                  .push(createFadeRoute(const ChangePasswordPage()));
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
              if (value) {
                _authenticateWithBiometrics();
              } else {
                _updateBiometricEnabled(value);
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle about us action
              Navigator.of(context).push(createFadeRoute(AboutUsPage()));
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
