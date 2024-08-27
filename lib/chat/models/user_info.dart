// lib/chat/models/user_info.dart

class UserInfo {
  final int id;
  final String nickName;
  final String avatarPath;
  // loginId 필드를 추가
  final String loginId;

  UserInfo(
      {required this.id,
      required this.nickName,
      required this.avatarPath,
      required this.loginId});
}
