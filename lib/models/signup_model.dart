
import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:todomate/screens/todo/todo_model.dart'; // Todo 모델의 경로를 올바르게 수정하세요


import 'package:todomate/models/diary_model.dart';


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
    // deleteDatabase(path);
    return await openDatabase(
      path,
      version: 3, // 데이터베이스 버전 업데이트
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  //데이터 베이스 테이블 만듬
  Future<void> _onCreate(Database db, int version) async {
    print('Creating tables in version $version');
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        login_id TEXT UNIQUE,
        nickname TEXT,
        password TEXT,
        avatar_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE diary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        title TEXT,
        description TEXT,
        imageUrl TEXT,
        createAt TEXT
      )
    ''');

  }

  // 데이터베이스 버전이 업데이트 되었을 때 Diarys 테이블 생성
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('oldversion : $oldVersion , newVersion : $newVersion ');
      CREATE TABLE friend_requests(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER,
        receiver_id INTEGER,
        status TEXT,
        FOREIGN KEY(sender_id) REFERENCES users(id),
        FOREIGN KEY(receiver_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT,
        start_date TEXT,
        end_date TEXT,
        color INTEGER,
        is_completed INTEGER,
        shared_with_friend INTEGER,
        friend_id TEXT,
        FOREIGN KEY(user_id) REFERENCES users(login_id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE todos (
          id TEXT PRIMARY KEY,
          user_id TEXT,
          title TEXT,
          start_date TEXT,
          end_date TEXT,
          color INTEGER,
          is_completed INTEGER,
          shared_with_friend INTEGER,
          friend_id TEXT,
          FOREIGN KEY(user_id) REFERENCES users(login_id)
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE friend_requests(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sender_id INTEGER,
          receiver_id INTEGER,
          status TEXT,
          FOREIGN KEY(sender_id) REFERENCES users(id),
          FOREIGN KEY(receiver_id) REFERENCES users(id)
        )
      ''');
    }
  }

//해시화
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

  //데이터베이스에 비동기 인데 기다려야 한다???
  //데이터베이스 쿼리가 완료되어 결과가 반환될 때까지 코드를 일시 중단하고,
  // 작업이 끝나면 그 결과를 사용하여 다음 작업을 계속 진행
  //즉 쿼리 다 작성되는데까지 기다린다는 뜻
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database; //await 로 기다려야 한다.
    return await db.query('users'); //
  }

  //로그인시 아이디 중복 확인
  Future<Map<String, dynamic>?> getUser(String loginId, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);

    try {
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'login_id = ?',
        whereArgs: [loginId],
      );

      if (results.isNotEmpty) {
        Map<String, dynamic> user = results.first;
        if (user['password'] == hashedPassword) {
          return {
            'id': user['id'],
            'login_id': user['login_id'],
            'nickname': user['nickname'],
            'avatar_path': user['avatar_path'],
          };
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error in getUser: $e');
      return null;
    }
  }

  //로그인 과정
  Future<Map<String, dynamic>> loginUser(
      String loginId, String password) async {
    try {
      await ensurePasswordsAreHashed(); // 로그인 전에 비밀번호 해시 확인
      final user = await getUser(loginId, password);
      if (user != null) {
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
        return {
          "success": false,
          "message": "아이디 또는 비밀번호가 올바르지 않습니다."
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "로그인 중 오류가 발생했습니다: $e"
      };
    }
  }

  //비번 검사
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

  //DB에 유저정보 업데이트
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // 여기 왜 삭제가 또 있지? 불안하게....?
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//////////////////////////////////////////
  //닉네임 연동
  Future<String?> getNickname(String loginId) async {
    //* 약 118~127번째 줄
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['nickname'],
      where: 'login_id = ?',
      whereArgs: [loginId],
    );

    if (results.isNotEmpty) {
      return results.first['nickname'] as String?;
    } else {
      return null;
    }
  }

  //닉네임 변경
  Future<int> updateNickname(String loginId, String newNickname) async {
    Database db = await database;
    return await db.update(
      'users',
      {'nickname': newNickname},
      where: 'login_id = ?',
      whereArgs: [loginId],
    );
  }

  // 회원 탈퇴 기능 추가
  Future<int> deleteUserByLoginId(String loginId) async {
    Database db = await database;
    // login_id를 기반으로 사용자를 삭제
    return await db.delete(
      'users',
      where: 'login_id = ?', // 'login_id' 열이 특정 값과 일치하는 행을 찾음
      whereArgs: [loginId], // '?'를 'loginId' 값으로 대체함
    );
  }

  /////////////////////////////////////

  //해시 패스워드 업데이트
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
  }


  //Diary Insert
  Future<bool> insertDiary(DiaryDTO diary) async {
    final db = await database;
    try{
      await db.insert(
          'diary',
          diary.toJson(),
          conflictAlgorithm: ConflictAlgorithm.fail //primary 키 중복일 경우 에러
      );
      return true;
    }catch (e){
      print('Insert Database error $e');
      return false;
    }

  }


  //전체 Diary 날짜 리스트
  Future<List<DiaryDTO>> getDiaryList() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'diary',
      columns: ['id','userId', 'title', 'description', 'imageUrl', 'createAt'], // dateTime 필드만 선택
    );

    // Map을 DiaryDTO list로 반환
    return List<DiaryDTO>.from(
      maps.map((map) => DiaryDTO.fromJson(map)),
    );
  }


  //Diary Delete
  Future<bool> deleteDiary(int id) async {
    try{
      Database db = await database;
      await db.delete(
        'diary',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    }catch (e){
      print('Delete Database error $e');
      return false;
    }
  }

  //테이블 만들어졌는지 확인
  Future<void> checkTables() async {
    final Database db = await database;

    // 테이블 목록 가져오기
    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';"
    );

    // 테이블 목록 출력
    for (var table in tables) {
      print('Table: ${table['name']}');
    }
  }


}

  Future<List<Map<String, dynamic>>> getFriendRequests(String userId) async {
    Database db = await database;
    return await db.query(
      'friend_requests',
      where: 'receiver_id = ? AND status = ?',
      whereArgs: [userId, 'pending'],
    );
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query, String userId) async {
    Database db = await database;
    return await db.query(
      'users',
      where: 'nickname LIKE ? AND id != ?',
      whereArgs: ['%$query%', userId],
    );
  }

  Future<void> sendFriendRequest(String userId, String friendId) async {
    Database db = await database;
    try {
      await db.insert('friend_requests', {
        'sender_id': userId,
        'receiver_id': friendId,
        'status': 'pending',
      });
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  Future<void> acceptFriendRequest(String userId, String friendId) async {
    Database db = await database;
    try {
      await db.update(
        'friend_requests',
        {'status': 'accepted'},
        where: 'sender_id = ? AND receiver_id = ?',
        whereArgs: [friendId, userId],
      );
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  Future<List<Todo>> getTodos(String userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> insertTodo(Todo todo) async {
    Database db = await database;
    try {
      await db.insert('todos', todo.toMap());
    } catch (e) {
      print('Error inserting todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    Database db = await database;
    try {
      await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    Database db = await database;
    try {
      await db.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [todoId],
      );
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
