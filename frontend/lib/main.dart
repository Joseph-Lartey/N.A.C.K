import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/otp.dart'; // Import the OTP service
import 'WelcomeScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  OTPService.configure(); // Configure the OTP service
  runApp(const MyApp());
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
          seedColor: Colors.white, // Set the seed color to white
          brightness: Brightness.light, // Ensure light theme
        ),
        scaffoldBackgroundColor:
            Colors.white, // Set scaffold background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background to white
          iconTheme:
              IconThemeData(color: Colors.black), // Icon color for AppBar
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
      ),
      home: const SplashScreen(), // SplashScreen as the home widget
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delay navigation to WelcomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFB7425D), // Color at the bottom
              Color(0xFF884244), // Color at the top
            ],
          ),
        ),
        // You can add your logo or any other content here
        child: Center(
          child: Center(
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
