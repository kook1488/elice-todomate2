import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';


class UserProvider with ChangeNotifier {
  DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> registerUser(Map<String, dynamic> user) async {
    await _dbHelper.insertUser(user);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> loginUser(String loginId, String password) async {
    return await _dbHelper.loginUser(loginId, password);
  }

  Future<void> sendFriendRequest(String userId, String friendId) async {
    await _dbHelper.sendFriendRequest(userId, friendId);
    notifyListeners();
  }

  Future<void> acceptFriendRequest(String userId, String friendId) async {
    await _dbHelper.acceptFriendRequest(userId, friendId);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query, String userId) async {
    return await _dbHelper.searchUsers(query, userId);
  }

  Future<List<Map<String, dynamic>>> getFriendRequests(String userId) async {
    return await _dbHelper.getFriendRequests(userId);
  }
}
