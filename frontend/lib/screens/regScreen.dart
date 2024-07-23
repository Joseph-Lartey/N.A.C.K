import 'package:flutter/material.dart';
import '../services/otp.dart'; // Import the OTP service
import 'otpPage.dart'; // Import the OTP page
import 'loginScreen.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(_checkButtonState);
    lastNameController.addListener(_checkButtonState);
    emailController.addListener(_checkButtonState);
    passwordController.addListener(_checkButtonState);
    confirmPasswordController.addListener(_checkButtonState);
    dobController.addListener(_checkButtonState);
    classController.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    classController.dispose();
    
    super.dispose();
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          dobController.text.isNotEmpty &&
          classController.text.isNotEmpty;
    });
  }

  void _sendOTP() {
    OTPService.sendOTP(emailController.text);
    Navigator.push(
      context,
      _createRoute(
        OtpPage(
          email: emailController.text,
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          dob: dobController.text
        )
      ),
    );
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


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        _checkButtonState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 66, 91),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 183, 66, 91),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Up to  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              "N.A.C.K",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color.fromARGB(255, 183, 66, 91),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome back, Sign in using your social \n           or email to continue with us',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 125, 116, 116),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextField(

                                controller: firstNameController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(

                                    Icons.check,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 183, 66, 91),
                                  ),
                                ),
                                onChanged: (_) {
                                  _checkButtonState();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(

                                    Icons.check,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 183, 66, 91),
                                  ),
                                ),
                                onChanged: (_) {
                                  _checkButtonState();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          labelText: 'Email (Ashesi email)',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dobController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                              labelText: 'Date of Birth',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 183, 66, 91),
                              ),
                            ),
                            onChanged: (_) {
                              _checkButtonState();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: classController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.school,
                            color: Colors.grey,
                          ),
                          labelText: 'Class',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 60),
                      GestureDetector(
                        onTap: _isButtonEnabled ? _sendOTP : null,
                        child: Container(
                          height: 63,
                          width: 327,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _isButtonEnabled
                                ? const Color.fromARGB(255, 183, 66, 91)
                                : Colors.grey, // Adjusted color based on state
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createRoute(const LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Have an account already?  Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 183,                               66, 91),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

