class API {
  static const hostConnect = "http://172.30.1.57/aip_new_members"; // 올바른 호스트 경로
  static const hostConnectUser = "$hostConnect/user";

  static const signup = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php"; // 로그인 API URL
  static const validatenickname = "$hostConnectUser/validate_nickname.php";
}
