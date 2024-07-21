// example
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  String? _socketChannel;
  bool? _registrationSuccess;

  User? get user => _user;
  String? get token => _token;
  String? get socketChannel => _socketChannel;
  bool? get registrationSuccess => _registrationSuccess;
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
      _token = loginResponse['token'];

      // Get the profile details of the user
      _user = User.fromJson(await _authService.getProfile(loginResponse['id']));
      _socketChannel = loginResponse['socket-channel'];

      setLoading(false);
    } catch (e) {
      print(e);
    }
  }

  // Create user
  Future<void> register(String firstname, String lastname, String username,
      String email, String password, String gender, String dob) async {
    setLoading(true);

    try {
      final registerResponse = await _authService.register(
          firstname, lastname, username, email, password, gender, dob);

      if (registerResponse['success'] == true) {
        _registrationSuccess = true;
      }
    } catch (e) {
      _registrationSuccess = false;
      print(e);
    }

    setLoading(false);
  }
}
