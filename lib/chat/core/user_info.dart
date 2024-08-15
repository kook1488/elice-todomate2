// lib/chat/models/user_info.dart

class UserInfo {
  final int id;
  final String nickName;
  final String avatarPath;

  UserInfo({required this.id, required this.nickName, required this.avatarPath});
}

/* 코드를 좀더 보기 좋게 하려고 // 를 사용하지 않음.
import 'package:sqflite/sqflite.dart';  // 로컬 DB를 위한 패키지 예시
// import 'package:http/http.dart' as http;  // 서버 통신을 위한 패키지 예시

class UserInfo {
  final int id;
  final String nickName;
  final String avatarPath;

  UserInfo({required this.id, required this.nickName, required this.avatarPath});

  // DB에서 사용자 정보를 가져오는 메서드
  static Future<UserInfo?> getUserFromDB(int userId) async {
    // 여기에 DB 쿼리 로직 구현
    // 예: final db = await openDatabase('your_db.db');
    // final result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    // if (result.isNotEmpty) {
    //   return UserInfo.fromMap(result.first);
    // }
    // return null;
  }

  // 로그인 정보로 사용자 정보를 가져오는 메서드
  static Future<UserInfo?> loginUser(String username, String password) async {
    // 여기에 로그인 로직 구현
    // 예: final response = await http.post('your_login_api_url', body: {'username': username, 'password': password});
    // if (response.statusCode == 200) {
    //   final userData = json.decode(response.body);
    //   return UserInfo.fromJson(userData);
    // }
    // return null;
  }

  // UserInfo 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickName': nickName,
      'avatarPath': avatarPath,
    };
  }

  // Map에서 UserInfo 객체 생성
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      nickName: map['nickName'],
      avatarPath: map['avatarPath'],
    );
  }

  // 서버에서 받은 JSON 데이터로 UserInfo 객체 생성
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      nickName: json['nickName'],
      avatarPath: json['avatarPath'],
    );
  }
}
*/