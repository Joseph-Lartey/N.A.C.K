import 'package:flutter/material.dart';
import 'loginScreen.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Icon(
              Icons.email,
              size: 200,
              color: Color.fromARGB(255, 183, 66, 91),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the email address associated with your account and we\'ll send an email with a confirmation to reset your password.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter email',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 183, 66, 91),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('OTP Sent'),
                        content: const Text(
                          'An OTP has been sent to your email. Please input that OTP as your password on the login page. You will be required to change your password right after logging in using the OTP.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Continue to Login'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(true); // Return true
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
