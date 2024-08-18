import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//클래스(틀) ,객체=인스턴스 (한국어와 외국어차이:실행중인게 인스턴스라는데 모르겠다)
class DatabaseHelper {
  //클래스(붕어빵) 객체=인스턴스 였다...!
  //예를들어 회사 복사기= 객체 모두가 이 복사기를 쓰니깐
  //  복사기만드는 기계(디비헬퍼)-복사기(객체=instance)1개로 가져다 쓴다- 회사에서 사람마다 다르게 복사해줌
  //  복사기 1개로 가져다 쓰는게 싱글톤 패턴- 큰 기계 하나로 모든 일을 처리하는것

  //인스턴스 이름이 인스턴스 이다. 싱글톤패턴이라 1개만 쓰니깐.
  static final DatabaseHelper _instance1 = DatabaseHelper._internal();
  //static final 데이터베이스를 여러개를 만들지 않고 하나만 쓰려고 한다.
  //static : static 이후의 변수가  DatabaseHelper 클래스자체에 속한다고
  // 클래스의 인스턴스가 공유한다 복사기 공용으로 쓰듯이

  //final : 데이터베이스 이거 하나만 쓰려고 한다.
  //그렇기에 한번만 초기화 될 수 있고 처음 할당된 이후에는 값이 변경되지 않는다
  // _instance1 이게 그 변수 이름이다. DatabaseHelper클래스가 사용하는 딱 하나의 인스턴스 이름.
  //호출할때 클래스를 부른다는데, 이거를 불러도 되지 않을까 싶다

  factory DatabaseHelper() => _instance1;
  //생성자이름이 instance1 이다
  //싱글톤을 실제로 구현하면 factory를 쓴다
  //항상동일한 객체를 내보내려고

  static Database? _database;
  DatabaseHelper._internal(); //생성자 정의 _이거 의미는
  // 프라이빗 생성자로써 이 생성자가 외부에서 호출될 수 없음을 의미한다.
// 다른 클래스에서 DatabaseHelper 를 생성하거나 새로운 인스턴스를
  // 생성하지 못하도록 제한하는것

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

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
