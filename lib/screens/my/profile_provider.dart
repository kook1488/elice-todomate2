import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';

class ProfileProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // DB 불러옴
  String? _nickname;
  String _avatarPath = 'asset/image/avata_1.png'; // 기본 아바타 경로로 초기화

  // 프로필 관련 상태
  int _todoCount = 7;
  int _completedTodoCount = 5;
  int _diaryCount = 1;
  int _friendCount = 4;
  int _activeChatCount = 5;
  int _reservedChatCount = 2;

  // Getter 메서드
  String? get nickname => _nickname;
  String get avatarPath => _avatarPath;
  int get todoCount => _todoCount;
  int get completedTodoCount => _completedTodoCount;
  int get diaryCount => _diaryCount;
  int get friendCount => _friendCount;
  int get activeChatCount => _activeChatCount;
  int get reservedChatCount => _reservedChatCount;

  // 데이터베이스에서 닉네임 가져옴
  Future<void> loadNickname(String loginId) async {
    _nickname = await _dbHelper.getNickname(loginId);
    if (_nickname == null || _nickname!.isEmpty) {
      _nickname = loginId; // 기본 닉네임을 로그인 아이디로 설정
      await _dbHelper.updateNickname(loginId, _nickname!); // 기본 닉네임 저장
    }
    notifyListeners();
  }

  // 닉네임 상태 변경
  Future<void> updateNickname(String loginId, String newNickname) async {
    await _dbHelper.updateNickname(loginId, newNickname); // 데이터베이스에 닉네임 업데이트
    _nickname = newNickname;
    notifyListeners();
  }

  // 아바타 이미지 변경
  Future<void> updateAvatarPath(String loginId, String newAvatarPath) async {
    _avatarPath = newAvatarPath; // 새로운 프로필 이미지 경로를 설정
    notifyListeners();
  }

  // 각 상태를 업데이트하는 메서드 추가
  void updateTodoCount(int count) {
    _todoCount = count;
    notifyListeners();
  }

  void updateCompletedTodoCount(int count) {
    _completedTodoCount = count;
    notifyListeners();
  }

  void updateDiaryCount(int count) {
    _diaryCount = count;
    notifyListeners();
  }

  void updateFriendCount(int count) {
    _friendCount = count;
    notifyListeners();
  }

  void updateActiveChatCount(int count) {
    _activeChatCount = count;
    notifyListeners();
  }

  void updateReservedChatCount(int count) {
    _reservedChatCount = count;
    notifyListeners();
  }

// 기타 필요한 메서드들 추가 가능
}
