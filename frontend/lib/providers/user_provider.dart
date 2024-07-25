import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:untitled3/models/other_user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<OtherUser> _users = [];
  List<OtherUser> _matchedUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<int, int> _userMatchIds = {};

  List<OtherUser> get users => _users;
  List<OtherUser> get matchedUsers => _matchedUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<int, int> get userMatchIds => _userMatchIds;

  // Fetch all users
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _notifyListenersSafely();

    try {
      _users = await _userService.getAllUsers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _notifyListenersSafely();
  }

  // Fetch matched users for a specific user
  Future<void> fetchMatchedUsers(int userId) async {
    _isLoading = true;
    _notifyListenersSafely();

    try {
      // Fetch matches for the user
      final matchMap = await _userService.getMatchesForUser(userId);

      // Update _matchedUsers and _userMatchIds
      _matchedUsers = _users.where((user) {
        final isMatched = matchMap.containsKey(user.userId);
        if (isMatched) {
          // Update the _userMatchIds map
          _userMatchIds[user.userId] = matchMap[user.userId]!;
        }
        return isMatched;
      }).toList();

      print("happily converted");

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _notifyListenersSafely();
  }

  int? getMatchIdForUser(int userId) {
    return _userMatchIds[userId];
  }

  // Notify listeners safely
  void _notifyListenersSafely() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
