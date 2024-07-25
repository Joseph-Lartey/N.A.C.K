import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:untitled3/screens/homePage.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'services/chat_service.dart';
import 'services/otp.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  OTPService.configure(); // Configure the OTP service
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final biometricEnabled = prefs.getBool('biometricEnabled') ?? false;

    print('Stored email: $email');
    print('Stored password: $password');
    print('Biometric enabled: $biometricEnabled');

    if (email != null && password != null) {
      if (biometricEnabled) {
        print('Attempting biometric authentication...');
        bool authenticated = await _authenticateWithBiometrics();
        if (authenticated) {
          print('Biometric authentication successful');
          _login(email, password);
        } else {
          print('Biometric authentication failed');
          _navigateToLogin();
        }
      } else {
        print('Logging in with stored credentials...');
        _login(email, password);
      }
    } else {
      print('No stored credentials found');
      _navigateToWelcome();
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  void _login(String email, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print('Attempting to log in user with email: $email');
    await authProvider.login(email, password);
    if (authProvider.loginSuccess == true) {
      print('Login successful');
      if (!mounted) return; // Check if the widget is still in the widget tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      print('Login failed: ${authProvider.errorMessage}');
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    print('Navigating to LoginScreen');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToWelcome() {
    print('Navigating to WelcomeScreen');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFB7425D),
              Color(0xFF884244),
            ],
          ),
        ),
        child: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
