// lib/chat/models/user_info.dart

class UserInfo {
  final int id;
  final String nickName;
  final String avatarPath;
  final String loginId; // loginId 필드를 추가

  UserInfo(
      {required this.id, required this.nickName, required this.avatarPath});
}
