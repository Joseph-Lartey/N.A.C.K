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
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(60), // Adjust the preferred size here
        child: AppBar(
          backgroundColor: Colors.white, // WhatsApp green
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/img2.jpg'),
            ),
          ),
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {
                // Action for notifications
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(151, 151, 151, 0.7),
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(151, 151, 151, 0.13),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 10.0,
                ),
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
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    final message = filteredMessages.elementAt(index);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0, // Adjust vertical padding here
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
                                  color: const Color(0xFFB7425B),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  message.unreadCount.toString(),
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
                            message.time,
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
  final String time;
  final int unreadCount;

  Message({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
}

// Sample messages list
List<Message> messages = [
  Message(
    name: 'Jasmine Young',
    avatar: 'assets/img1.jpg',
    lastMessage: 'Last night was great?',
    time: '2 mins ago',
    unreadCount: 3,
  ),
  Message(
    name: 'Jessica Stain',
    avatar: 'assets/img2.jpg',
    lastMessage: "Let's meet up for coffee tomorrow.",
    time: '5 mins ago',
    unreadCount: 1,
  ),
  Message(
    name: 'Emma Watson',
    avatar: 'assets/img3.jpg',
    lastMessage: 'I will be there in 5 minutes.',
    time: '10 mins ago',
    unreadCount: 5,
  ),

  // Add more messages here
];
