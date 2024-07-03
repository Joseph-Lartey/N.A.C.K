import 'package:flutter/material.dart';
import 'navbar.dart'; // Ensure CustomBottomAppBar is implemented here
import 'chatscreen.dart'; // Ensure ChatScreen is implemented correctly

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB7425B), // WhatsApp green
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/img2.jpg'),
          ),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
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
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ),
          // List of messages
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _searchQuery,
              builder: (context, query, _) {
                final filteredMessages = messages.where((message) =>
                    message.name.toLowerCase().contains(query.toLowerCase()));

                return ListView.separated(
                  itemCount: filteredMessages.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final message = filteredMessages.elementAt(index);
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0, // Adjust vertical padding here
                      ),
                      onTap: () {
                        // Navigate to chat screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(message),
                          ),
                        );
                      },
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(message.avatar),
                            radius: 30,
                          ),
                          if (index % 2 ==
                              0) // Example condition for unread badge
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB7425B),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  '3',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        message.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        message.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '2 min ago',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}

// Sample data model for messages
class Message {
  final String name;
  final String avatar;
  final String lastMessage;

  Message({
    required this.name,
    required this.avatar,
    required this.lastMessage,
  });
}

// Sample messages list
List<Message> messages = [
  Message(
    name: 'Alex Linderson',
    avatar: 'assets/img1.jpg',
    lastMessage: 'How are you today?',
  ),
  Message(
    name: 'Team Align',
    avatar: 'assets/img2.jpg',
    lastMessage: 'Don’t miss to attend the meeting.',
  ),
  // Add more messages here
];
