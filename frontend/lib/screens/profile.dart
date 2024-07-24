import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/auth_provider.dart';
import '../widgets/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userProfileImage =
        'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${user?.profileImage ?? 'default_user.png'}';

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                            right: -10,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.black),
                              onPressed: () {
                                // Add your camera button action here
                              },
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
                        onEdit: (newValue) {
                          setState(() {
                            user?.firstName = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Last Name',
                        value: user?.lastName ?? '',
                        onEdit: (newValue) {
                          setState(() {
                            user?.lastName = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Username',
                        value: user?.username ?? '',
                        onEdit: (newValue) {
                          setState(() {
                            user?.username = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Email Address',
                        value: user?.email ?? '',
                        onEdit: (newValue) {
                          setState(() {
                            user?.email = newValue;
                          });
                        },
                      ),
                      ProfileInfoRow(
                        label: 'Bio',
                        value: user?.bio ?? '',
                        onEdit: (newValue) {
                          setState(() {
                            user?.bio = newValue;
                          });
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
              editProfileInfo(context, label, value, onEdit);
            },
          ),
        ],
      ),
    );
  }

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
}
