// lib/models/user_info_singleton.dart

class UserInfoSingleton {
  // 싱글톤 인스턴스를 저장할 정적 변수
  static final UserInfoSingleton _instance = UserInfoSingleton._internal();

  // 상태를 저장할 변수
  String loginId = "defaultLoginId";

  // private 생성자
  UserInfoSingleton._internal();

  // 싱글톤 인스턴스를 반환하는 팩토리 생성자
  factory UserInfoSingleton() {
    return _instance;
  }

  // 상태를 업데이트하는 메서드
  void updateLoginId(String newLoginId) {
    loginId = newLoginId;
  }
}
