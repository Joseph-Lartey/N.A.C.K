import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'interests.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _selectedGender;
  File? _imageSelected;

  bool _showUsernameError = false;
  bool _showBioError = false;
  bool _showImageError = false;
  bool _showGenderError = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_clearErrors);
    _bioController.addListener(_clearErrors);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _showUsernameError = false;
      _showBioError = false;
      _showGenderError = false;
    });
  }

  Future<void> selectImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _imageSelected = File(image.path);
        _showImageError = false;
      });

      print(
          "The image path is: ${path.extension(_imageSelected!.path).toLowerCase()}");
    }
  }

  Future<void> uploadImage(int? userId) async {
    if (_imageSelected == null) return;

    final imageExtension =
        path.extension(_imageSelected!.path).replaceAll('.', '');
    final mediaType = MediaType('image', imageExtension);

    final uri =
        Uri.parse('http://16.171.150.101/N.A.C.K/backend/upload/$userId');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
          'profile_image', _imageSelected!.path,
          contentType: mediaType));
    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      final responseBody = await response.stream.bytesToString();

      print("status code: ${response.statusCode}");
      print("the response is: ${responseBody}");
      print('Failed to upload image');
    }
  }

  Future<void> _registerAndLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.registrationDetails['email'];
    final firstname = authProvider.registrationDetails['firstname'];
    final lastname = authProvider.registrationDetails['lastname'];
    final username = authProvider.registrationDetails['username'];
    final password = authProvider.registrationDetails['password'];
    final passwordx = authProvider.registrationDetails['password'];
    final dob = authProvider.registrationDetails['dob'];

    print('Attempting registration with email: $email, username: $username');
    print(
        'Registration details - firstname: $firstname, lastname: $lastname, dob: $dob, password:$password , confirmpassword:$passwordx');

    if (email != null &&
        password != null &&
        firstname != null &&
        lastname != null &&
        dob != null) {
      final response = await http.post(
        Uri.parse('http://16.171.150.101/N.A.C.K/backend/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirm_password': passwordx,
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
          'dob': dob,
        }),
      );
      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          // Registration successful, login the user
          await authProvider.login(email, password);
          if (authProvider.user != null) {
            final userId = authProvider.user!.userId;

            // Create profile
            final profileResponse = await http.post(
              Uri.parse('http://16.171.150.101/N.A.C.K/backend/profile'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'userId': userId,
                'username': _usernameController.text,
                'gender': _selectedGender,
                'bio': _bioController.text,
              }),
            );

            print(
                'Profile creation response status: ${profileResponse.statusCode}');
            print('Profile creation response body: ${profileResponse.body}');

            if (profileResponse.statusCode == 200) {
              final profileResponseBody = jsonDecode(profileResponse.body);
              if (profileResponseBody['success']) {
                await uploadImage(userId);
                Navigator.of(context).push(_createRoute(InterestsPage(
                  userId: userId,
                )));
              } else {
                print('Profile creation failed!');
              }
            } else {
              print('Profile creation request failed!');
            }
          } else {
            print('Login failed!');
          }
        } else {
          print('Registration failed!');
        }
      } else {
        print('Registration request failed!');
      }
    } else {
      print('Required registration details are missing!');
    }
  }

  Route _createRoute(Widget page) {
    print("called routing function");
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

  void _validateAndContinue() {
    setState(() {
      _showUsernameError = _usernameController.text.isEmpty ||
          !_usernameController.text.startsWith(RegExp(r'^[A-Za-z]'));
      _showBioError = _bioController.text.isEmpty;
      _showGenderError = _selectedGender == null;
      _showImageError = _imageSelected == null;
    });

    if (!_showUsernameError &&
        !_showBioError &&
        !_showGenderError &&
        !_showImageError) {
      _registerAndLogin();
    }
  }

  // void _createProfile(int? userId) async {
  //   print("working");

  //   final response = await http.post(
  //       Uri.parse('http://16.171.150.101/N.A.C.K/backend/profile'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'userId': userId,
  //         'username': _usernameController.text,
  //         'gender': _selectedGender,
  //         'bio': _bioController.text,
  //       }));

  //   print(response.body);

  //   if (response.statusCode == 500 || response.statusCode == 503) {
  //     throw Exception("Server error");
  //   } else {
  //     await uploadImage(userId);

  //     print("route");
  //     // Navigate to InterestsPage with the required data
  //     Navigator.of(context).push(_createRoute(InterestsPage(
  //       userId: userId!,
  //     )));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Who Are ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "YOU?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 183, 66, 91),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details to set up your profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: selectImageFromGallery,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageSelected != null
                        ? FileImage(_imageSelected!)
                        : null,
                    child: _imageSelected == null
                        ? Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt,
                                  color: Colors.grey[700], size: 30),
                              onPressed: selectImageFromGallery,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 183, 66, 91),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      onTap: selectImageFromGallery,
                    ),
                  ),
                ],
              ),
            ),
            if (_showImageError) const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Please select an image.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB7425B),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                errorText: _showUsernameError
                    ? 'Username is required and must start with a letter.'
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildGenderSelector(),
            if (_showGenderError)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please select a gender.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB7425B),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write a short bio',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 215, 215, 215)),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                errorText: _showBioError ? 'Bio is required.' : null,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 183, 66, 91),
              ),
              onPressed: _validateAndContinue,
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFB7425B),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
              _showGenderError = false;
            });
          },
          items: <String>['Male', 'Female', 'Other', 'Prefer not to say']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value.toLowerCase(),
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
