import 'package:flutter/material.dart';
import 'navbar.dart';
import 'chatscreen.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/img2.jpg'),
              radius: 20,
            ),
            SizedBox(width: 10),
            Text('Messages', style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Action for notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
          ),
          // List of messages
          Expanded(
            child: ListView.builder(
              itemCount: messages.length, // Number of messages
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(messages[index].avatar),
                  ),
                  title: Text(messages[index].name),
                  subtitle: Text(messages[index].lastMessage),
                  onTap: () {
                    // Navigate to chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(messages[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: CustomBottomAppBar(),
      ),
    );
  }
}

// Sample data model for messages
class Message {
  final String name;
  final String avatar;
  final String lastMessage;

  Message(
      {required this.name, required this.avatar, required this.lastMessage});
}

// Sample messages list
List<Message> messages = [
  Message(
      name: 'John Doe', avatar: 'assets/avatar1.jpg', lastMessage: 'Hello!'),
  Message(
      name: 'Jane Smith',
      avatar: 'assets/avatar2.jpg',
      lastMessage: 'How are you?'),
  // Add more messages here
];
