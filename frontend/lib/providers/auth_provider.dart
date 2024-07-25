import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoading = false;

  User? get user => _user;
  String? get token => _token;
  String? get socketChannel => _socketChannel;
  bool? get registrationSuccess => _registrationSuccess;
  bool? get loginSuccess => _loginSuccess;
  String? get errorMessage => _errorMessage;

  // Temporarily store registration details
  Map<String, String> _registrationDetails = {};

  Map<String, String> get registrationDetails => _registrationDetails;

  // Set loading state
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Set registration details
  void setRegistrationDetails(Map<String, String> details) {
    _registrationDetails = details;
    notifyListeners();
  }

  // Clear registration details
  void clearRegistrationDetails() {
    _registrationDetails.clear();
    notifyListeners();
  }

  // User login
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

        // Save login state to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', _token!);
        await prefs.setString('user', _user!.toJson() as String);
        print('User logged in, state saved.');
      } else {
        _loginSuccess = false;
        _errorMessage = loginResponse['error'];
      }

      setLoading(false);
    } catch (e) {
      _loginSuccess = false;
      _errorMessage = e.toString();
      setLoading(false);
    }
  }

  // User logout
  Future<void> logout() async {
    setLoading(true);

    try {
      final logoutResponse = await _authService.logout();

      if (logoutResponse['success'] == true) {
        _loginSuccess = false;
        _user = null;
        _token = null;
        _socketChannel = null;

        // Clear login state from shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('token');
        await prefs.remove('user');
        print('User logged out, state cleared.');
      } else {
        _errorMessage = logoutResponse['error'];
      }

      setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      setLoading(false);
    }
  }

  // User registration
  // User registration
  Future<void> register() async {
    setLoading(true);
    try {
      final registerResponse = await _authService.register(
          _registrationDetails['firstname']!,
          _registrationDetails['lastname']!,
          _registrationDetails['username']!,
          _registrationDetails['email']!,
          _registrationDetails['password']!,
          _registrationDetails['dob']!);

      if (registerResponse['success'] == true) {
        _registrationSuccess = true;
        clearRegistrationDetails(); // Clear registration details after successful registration

        // Automatically log in the user after registration
        await login(
            _registrationDetails['email']!, _registrationDetails['password']!);
      } else {
        _registrationSuccess = false;
        _errorMessage = registerResponse['error'];
      }
      setLoading(false);
    } catch (e) {
      _registrationSuccess = false;
      _errorMessage = e.toString();
      setLoading(false);
    }
  }

  // Update user information
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
