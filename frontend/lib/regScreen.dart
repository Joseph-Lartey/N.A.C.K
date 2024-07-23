import 'package:flutter/material.dart';
import 'services/otp.dart'; // Import the OTP service
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      _createRoute(OtpPage(
          email: emailController.text,
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          dob: dobController.text)),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (value.length > 20) {
      return 'Password must be at most 20 characters long';
    }

    RegExp hasUppercase = RegExp(r'[A-Z]');
    RegExp hasLowercase = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!hasUppercase.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit.hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    String pattern = r'^[A-Za-z ]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    try {
      // Use the correct date format
      DateFormat dateFormat =
          DateFormat('yyyy-MM-dd'); // Changed to 'yyyy-MM-dd'
      DateTime date = dateFormat.parseStrict(value);

      if (date.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      DateTime today = DateTime.now();
      DateTime adultDate = DateTime(today.year - 18, today.month, today.day);
      if (date.isAfter(adultDate)) {
        return 'You must be at least 18 years old';
      }
    } catch (e) {
      return 'Please enter a valid date of birth (yyyy-MM-dd)'; // Changed to 'yyyy-MM-dd'
    }

    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your class year';
    }
    try {
      int year = int.parse(value);
      DateTime today = DateTime.now();
      if (year < today.year) {
        return 'Year must be ${today.year} or later';
      }
      if (year > today.year + 4) {
        return 'Year must be ${today.year + 4} or earlier';
      }
    } catch (e) {
      return 'Please enter a valid year';
    }

    return null;
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
                  child: Form(
                    key: _formKey,
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
                                child: TextFormField(
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
                                    validator: _validateName),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
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
                                    validator: _validateName),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 183, 66, 91),
                            ),
                          ),
                          onChanged: (_) {
                            _checkButtonState();
                          },
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
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
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
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
                          validator: _validateConfirmPassword,
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
                                validator: _validateDOB),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
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
                            validator: _validateYear),
                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: _isButtonEnabled ? _sendOTP : null,
                          child: Container(
                            height: 65,
                            width: 327,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _isButtonEnabled
                                  ? const Color.fromARGB(255, 183, 66, 91)
                                  : Colors
                                      .grey, // Adjusted color based on state
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
                                color: Color.fromARGB(255, 183, 66, 91),
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
          ),
        ],
      ),
    );
  }
}
