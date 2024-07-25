import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // final String baseUrl = "http://4.231.236.2/N.A.C.K/backend";
  final String baseUrl = "http://16.171.150.101/N.A.C.K/backend";

  // Register users
  Future<Map<String, dynamic>> register(String firstname, String lastname,
      String username, String email, String password, String dob) async {
    final response = await http.post(Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'username': lastname,
          'email': email,
          'password': password,
          'confirm_password': password,
          'dob': dob
        }));

    if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(response.body);
    }
  }

  // Log users into the application
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(response.body);
    }
  }

  //TODO: Create logout method

  // Get the profile details of a user
  Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get profile");
    }
  }

  // Log in with firebase
  ///Let user sign in with email and password
  ///
  /// // Log users out of the application
  Future<Map<String, dynamic>> logout() async {
    final response = await http.post(Uri.parse('$baseUrl/users/logout'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(response.body);
    }
  }
}
