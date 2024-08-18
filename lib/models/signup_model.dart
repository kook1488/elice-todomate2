import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//싱글톤으로 선언
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance; //객체를 다시쓴다! 주의 다시 공부하기
  static Database? _database;

  DatabaseHelper._internal(); //명명된 생성자로 사용함

  //DB 1개만 쓰려고
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //회원가입시 초기화
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //해커 침입 방지로 해시화
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        login_id TEXT UNIQUE,
        nickname TEXT,
        password TEXT,
        avatar_path TEXT
      )
    ''');
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

// 아이디 중복확인
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    user['password'] = _hashPassword(user['password']);
    try {
      return await db.insert('users', user);
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('사용자 아이디가 이미 존재합니다.');
      } else {
        throw e;
      }
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUser(String loginId, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);

    print('Querying database for user: $loginId');
    print('Hashed password: $hashedPassword');

    try {
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'login_id = ?',
        whereArgs: [loginId],
      );

      print('Query results: $results');

      if (results.isNotEmpty) {
        Map<String, dynamic> user = results.first;
        print('Stored hashed password: ${user['password']}');
        if (user['password'] == hashedPassword) {
          print('Password match for user: $loginId');
          return {
            'id': user['id'],
            'login_id': user['login_id'],
            'nickname': user['nickname'],
            'avatar_path': user['avatar_path'],
          };
        } else {
          print('Password mismatch for user: $loginId');
          return null;
        }
      } else {
        print('No user found with login_id: $loginId');
        return null;
      }
    } catch (e) {
      print('Error in getUser: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String loginId, String password) async {
    try {
      print('Attempting login for user: $loginId');
      await ensurePasswordsAreHashed(); // 로그인 전에 비밀번호 해시 확인
      final user = await getUser(loginId, password);
      print('getUser result: $user');
      if (user != null) {
        print('User found: ${user['nickname']}');
        return {
          "success": true,
          "user": {
            "id": user['id'],
            "nickname": user['nickname'],
            "avatar_path": user['avatar_path'] ?? 'default_avatar.png',
          },
          "message": "로그인에 성공했습니다."
        };
      } else {
        print('User not found or incorrect password');
        return {"success": false, "message": "아이디 또는 비밀번호가 올바르지 않습니다."};
      }
    } catch (e) {
      print('Error in loginUser: $e');
      return {"success": false, "message": "로그인 중 오류가 발생했습니다: $e"};
    }
  }

  Future<void> printAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users');
    print('All users in database:');
    for (var user in users) {
      var userCopy = Map<String, dynamic>.from(user);
      if (userCopy['password'] != null && userCopy['password'].length > 0) {
        int displayLength =
            userCopy['password'].length > 3 ? 3 : userCopy['password'].length;
        userCopy['password'] =
            userCopy['password'].substring(0, displayLength) + '***';
      } else {
        userCopy['password'] = '***';
      }
      print(userCopy);
    }
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//////////////////////////////////////////
  // 회원 탈퇴 기능 추가
  Future<int> deleteUserByLoginId(String loginId) async {
    Database db = await database;
    // login_id를 기반으로 사용자를 삭제
    return await db.delete(
      'users',
      where: 'login_id = ?',
      whereArgs: [loginId],
    );
  }

  /////////////////////////////////////
  Future<void> updatePasswordToHash() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users');
    for (var user in users) {
      if (user['password'].length != 64) {
        // SHA-256 해시는 64자
        String hashedPassword = _hashPassword(user['password']);
        await db.update('users', {'password': hashedPassword},
            where: 'id = ?', whereArgs: [user['id']]);
        print('Updated password for user: ${user['login_id']}');
      }
    }
  }

  Future<void> ensurePasswordsAreHashed() async {
    await updatePasswordToHash();
    print('All passwords have been checked and hashed if necessary.');
  }
}
