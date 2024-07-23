import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/auth_provider.dart';
import '../services/otp.dart'; // Import the OTP service
import 'profilesetup.dart'; // Import the InterestsPage

class OtpPage extends StatefulWidget {
  final String email;
  final String firstname;
  final String lastname;
  final String password;
  final String confirmPassword;
  final String dob;

  const OtpPage(
      {Key? key,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.password,
      required this.confirmPassword,
      required this.dob})
      : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  bool _isButtonEnabled = false;

  void _verifyOTP() async {
    bool isValid = OTPService.verifyOTP(otpController.text);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully!')),
      );

      // make register request to api
      await authProvider.register(
        widget.firstname,
        widget.lastname,
        widget.firstname,
        widget.email,
        widget.password,
        widget.dob,
      );

      if (authProvider.registrationSuccess == true) {
        // Log user in to set up user
        await authProvider.login(widget.email, widget.password);

        print("registration finished");
        print(authProvider.user);

        if (authProvider.user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User login failed!')),
          );
          return;
        }

        // navigate to profile setup page
        Navigator.push(
          context,
          _createRoute(ProfileSetupPage(
            userId: authProvider.user?.userId,
          )), // Using custom route transition
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP! Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    otpController.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = otpController.text.isNotEmpty;
    });
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 183, 66, 91),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 183, 66, 91),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          MediaQuery.of(context).padding.top,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text(
                              'User verification',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'OTP has been sent to your e-mail address, please enter the OTP in the bottom.',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            const Icon(
                              Icons.lock_outline,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 40),
                            TextField(
                              controller: otpController,
                              obscureText: true,
                              onChanged: (_) {
                                _checkButtonState();
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                labelText: 'Enter 6 digit OTP',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 183, 66, 91),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                height: 63,
                                width: 327,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _isButtonEnabled
                                      ? const Color.fromARGB(255, 183, 66, 91)
                                      : Colors
                                          .grey, // Adjusted color based on state
                                ),
                                child: TextButton(
                                  onPressed:
                                      _isButtonEnabled ? _verifyOTP : null,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Verify',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
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
