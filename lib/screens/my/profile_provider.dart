import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';

class ProfileProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String? _nickname;
  String? get nickname => _nickname;

  Future<void> loadNickname(String loginId) async {
    _nickname = await _dbHelper.getNickname(loginId); // 데이터베이스에서 닉네임 로드
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> updateNickname(String loginId, String newNickname) async {
    await _dbHelper.updateNickname(loginId, newNickname); // 데이터베이스에 닉네임 업데이트
    _nickname = newNickname;
    notifyListeners(); // 상태 변경 알림
  }
}
