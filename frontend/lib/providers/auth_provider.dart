// example
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  String? _socketChannel;
  bool _registrationSuccess = false;
  bool _loginSuccess = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  String? get socketChannel => _socketChannel;
  bool? get registrationSuccess => _registrationSuccess;
  bool? get loginSuccess => _loginSuccess;
  String? get errorMessage => _errorMessage;
  bool isLoading = false;

  // Communicate whether or not the fetch is loading
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Log user in
  Future<void> login(String email, String password) async {
    setLoading(true);

    try {
      final loginResponse = await _authService.login(email, password);

      if (loginResponse['success'] == true) {
        _loginSuccess = true;

        _token = loginResponse['token'];
        _socketChannel = loginResponse['socket-channel'];

        final profileDetails =
            await _authService.getProfile(loginResponse['id']);

        _user = User.fromJson(profileDetails);
        // print("user object: $_user");
      } else {
        _loginSuccess = false;
        _errorMessage = loginResponse['error'];
      }

      setLoading(false);
    } catch (e) {
      //TODO: Include bottom banner message
      print(e);
    }
  }

  // Create user
  Future<void> register(String firstname, String lastname, String username,
      String email, String password, String dob) async {
    setLoading(true);

    try {
      final registerResponse = await _authService.register(
          firstname, lastname, username, email, password, dob);

      if (registerResponse['success'] == true) {
        _registrationSuccess = true;
      }
    } catch (e) {
      _registrationSuccess = false;
      print("Error is: $e");
    }

    setLoading(false);
  }

  // Update user information
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
