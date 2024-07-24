import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/other_user.dart';

class UserService {
  final String baseUrl = "http://16.171.150.101/N.A.C.K/backend";

  // get all users in the database
  Future<List<OtherUser>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> usersJson = data['data'];
          List<OtherUser> users =
              usersJson.map((json) => OtherUser.fromJson(json)).toList();
          // BUG: check if users are diplsyed
          print('The users are $users');
          return users;
        } else {
          throw Exception('Error: ${data['error']}');
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  
}
