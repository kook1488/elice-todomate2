import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';

class ProfileProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper(); //DB불러옴

  //닉네임, 아바타 선언
  String? _nickname;
  String _avatarPath = 'asset/image/avata_1.png'; // 기본 아바타 경로로 초기화
  String? get nickname => _nickname;
  String? get avatarPath => _avatarPath;
// 데이터베이스에서 닉네임 가져옴
  Future<void> loadNickname(String loginId) async {
    _nickname = await _dbHelper.getNickname(loginId); //비동기인데 쿼리 가져올때까지는 기다림
    notifyListeners(); //프로바이더 구독하는 위젯들에게 상태 변경 알림-ui다시 빌드하라고
  }

//닉네임 상태변경
  Future<void> updateNickname(String loginId, String newNickname) async {
    await _dbHelper.updateNickname(loginId, newNickname); // 데이터베이스에 닉네임 업데이트
    _nickname = newNickname;
    notifyListeners();
  }

//아바타이미지 변경
  Future<void> updateAvatarPath(String loginId, String newAvatarPath) async {
    _avatarPath = newAvatarPath; // 새로운 프로필 이미지 경로를 설정
    notifyListeners();
  }
}
