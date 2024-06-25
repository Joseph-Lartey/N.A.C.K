import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'WelcomeScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: SplashScreen(), // SplashScreen as the home widget
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delay navigation to WelcomeScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
