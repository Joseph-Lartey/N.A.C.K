import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import '../providers/auth_provider.dart';
import '../widgets/navbar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageSelected;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _gender = 'not_specified'; // Default value for gender

  Future<void> selectImageFromGallery() async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _imageSelected = File(image.path);
      });

      final userId =
          Provider.of<AuthProvider>(context, listen: false).user?.userId;
      if (userId != null) {
        await uploadImage(userId.toString());
      }
    }
  }

  Future<void> uploadImage(String userId) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
    } else {
      final responseBody = await response.stream.bytesToString();
      print("Status code: ${response.statusCode}");
      print("Response: $responseBody");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  Future<void> updateUserInfo(
      String userId, String username, String bio) async {
    final response = await http.post(
      Uri.parse('http://16.171.150.101/N.A.C.K/backend/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'username': username,
        'bio': bio,
        'gender': _gender,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        authProvider.user?.username = username;
        authProvider.user?.bio = bio;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      print('Failed to update profile');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> fetchUserData() async {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).user?.userId;
    if (userId == null) {
      print('User ID is null');
      return;
    }

    try {
      print('Fetching user data for user ID: $userId');
      final response = await http.get(
        Uri.parse('http://16.171.150.101/N.A.C.K/backend/users/$userId'),
      );

      if (response.statusCode == 200) {
        print('User data fetched successfully');
        final data = jsonDecode(response.body);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        setState(() {
          authProvider.user?.username = data['username'];
          authProvider.user?.bio = data['bio'];
          authProvider.user?.firstName = data['firstName'];
          authProvider.user?.lastName = data['lastName'];
          authProvider.user?.email = data['email'];
          authProvider.user?.profileImage = data['profileImage'];
        });
      } else {
        print('Failed to fetch user data');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _handleRefresh() async {
    print('Pull to refresh started');
    await fetchUserData();
    setState(() {}); // Refresh the state to update the UI
    await Future.delayed(Duration(seconds: 2));
    print('Refresh complete');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userProfileImage =
        'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${user?.profileImage ?? 'default_user.png'}';

    _usernameController.text = user?.username ?? '';
    _bioController.text = user?.bio ?? '';
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 66, 91),
        elevation: 0, // Remove shadow
        automaticallyImplyLeading: false,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Color.fromARGB(255, 183, 66, 91),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        height: 100,
        showChildOpacityTransition: false,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 183, 66, 91),
                  height: 300, // Adjust the height as needed
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(80),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userProfileImage),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        color: Color.fromARGB(255, 183, 66, 91)),
                                    onPressed: selectImageFromGallery,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${user?.username ?? ''}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileInfoRow(
                            label: 'First Name',
                            value: user?.firstName ?? '',
                          ),
                          ProfileInfoRow(
                            label: 'Last Name',
                            value: user?.lastName ?? '',
                          ),
                          ProfileInfoRow(
                            label: 'Username',
                            value: user?.username ?? '',
                            onEdit: (newValue) {
                              setState(() {
                                user?.username = newValue;
                              });
                              if (user != null) {
                                updateUserInfo(user.userId.toString(), newValue,
                                    user.bio ?? '');
                              }
                            },
                          ),
                          ProfileInfoRow(
                            label: 'Email Address',
                            value: user?.email ?? '',
                          ),
                          ProfileInfoRow(
                            label: 'Bio',
                            value: user?.bio ?? '',
                            onEdit: (newValue) {
                              setState(() {
                                user?.bio = newValue;
                              });
                              if (user != null) {
                                updateUserInfo(user.userId.toString(),
                                    user.username ?? '', newValue);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 2),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Function(String)? onEdit;

  const ProfileInfoRow({
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                editProfileInfo(context, label, value, onEdit!);
              },
            ),
        ],
      ),
    );
  }

  void editProfileInfo(BuildContext context, String label, String currentValue,
      Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
