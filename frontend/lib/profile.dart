import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = 'Jhon';
  String lastName = 'Abraham';
  String username = 'Bomber';
  String email = 'jhonabraham20@gmail.com';
  String bio = 'Hey there! I\'m Alex, a 29-year-old musician who loves exploring new places and diving into a good book. When I\'m not strumming my guitar, you can find me hiking up a mountain or planning my next adventure. Looking for someone who enjoys great conversations, has a sense of humor, and is up for spontaneous road trips. Let\'s create some amazing memories together!';

  void editProfileInfo(BuildContext context, String label, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 183, 66, 91),
              padding: const EdgeInsets.fromLTRB(
                150.0, // left
                70.0, // top
                150.0, // right
                70.0, // bottom
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/img2.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Color.fromARGB(255, 183, 66, 91), size: 18),
                            onPressed: () {
                              // Handle camera button press
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jhon Abraham',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '@jhonabraham',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 183, 66, 91),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(
                    50.0, // left
                    50.0, // top
                    50.0, // right
                    150.0, // bottom
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileInfoRow(
                        label: 'First Name',
                        value: firstName,
                        onEdit: (newValue) {
                          setState(() {
                            firstName = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Last Name',
                        value: lastName,
                        onEdit: (newValue) {
                          setState(() {
                            lastName = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Username',
                        value: username,
                        onEdit: (newValue) {
                          setState(() {
                            username = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Email Address',
                        value: email,
                        onEdit: (newValue) {
                          setState(() {
                            email = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Bio',
                        value: bio,
                        onEdit: (newValue) {
                          setState(() {
                            bio = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onEdit;

  const ProfileInfoRow({
    required this.label,
    required this.value,
    required this.onEdit,
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
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              _editProfileInfo(context, label, value, onEdit);
            },
          ),
        ],
      ),
    );
  }

  void _editProfileInfo(BuildContext context, String label, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);

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
