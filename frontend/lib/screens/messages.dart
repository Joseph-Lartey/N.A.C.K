// chat_room_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/auth_provider.dart';
import 'package:untitled3/providers/user_provider.dart';
import '../widgets/navbar.dart';
import 'chatscreen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:math';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch all users and then fetch matched users for the logged-in user
    userProvider.fetchAllUsers().then((_) {
      userProvider.fetchMatchedUsers(authProvider.user?.userId ?? 0);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Fetch all users and then fetch matched users for the logged-in user
    await userProvider.fetchAllUsers();
    await userProvider.fetchMatchedUsers(authProvider.user?.userId ?? 0);

    // Shuffle messages for demonstration
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final matchedUsers = userProvider.matchedUsers;

    final userProfileImage =
        'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${authProvider.user?.profileImage ?? 'default_user.png'}';

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userProfileImage),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
            child: LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              color: Colors.white,
              backgroundColor: const Color.fromARGB(255, 183, 66, 91),
              height: 100,
              child: ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, query, _) {
                  final filteredUsers = matchedUsers.where((user) {
                    final fullName =
                        '${user.firstName} ${user.lastName}'.toLowerCase();
                    return fullName.contains(query.toLowerCase());
                  }).toList();

                  return ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.transparent,
                    ),
                    itemBuilder: (context, index) {
                      final user = filteredUsers.elementAt(index);
                      final bio = user.bio.length > 15
                          ? '${user.bio.substring(0, 15)}...'
                          : user.bio;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                        onTap: () {
                          final matchId =
                              userProvider.userMatchIds[user.userId];
                          if (matchId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    otherUser: user, matchId: matchId),
                              ),
                            );
                          } else {
                            print("Not a match");
                          }
                        },
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://16.171.150.101/N.A.C.K/backend/public/profile_images/${user.profileImage}'),
                              radius: 30,
                            ),
                          ],
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          bio,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
