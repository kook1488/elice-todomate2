class User {
  final int id;
  final String loginId;
  final String nickname;
  final String password;
  final String? avatarPath;

  User({
    required this.id,
    required this.loginId,
    required this.nickname,
    required this.password,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'login_id': loginId,
      'nickname': nickname,
      'password': password,
      'avatar_path': avatarPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      loginId: map['login_id'],
      nickname: map['nickname'],
      password: map['password'],
      avatarPath: map['avatar_path'],
    );
  }
}
