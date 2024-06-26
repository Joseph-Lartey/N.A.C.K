import 'package:flutter/material.dart';
import 'homePage.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _otpController.text.isNotEmpty;
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
                        'OTP has been sent to your e-mail address, please enter any one of the OTP in the bottom.',
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
                        controller: _otpController,
                        obscureText: true,
                        onChanged: (_) {
                          _checkButtonState();
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter 6 digit OTP',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 183, 66, 91),
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
                                : Colors.grey, // Adjusted color based on state
                          ),
                          child: TextButton(
                            onPressed: _isButtonEnabled
                                ? () {
                                    Navigator.push(
                                      context,
                                      _createRoute(const HomePage()),
                                    );
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
          ],
        ),
      ),
    );
  }
}
