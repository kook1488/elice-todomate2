import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todomate/models/diary_model.dart';
import 'package:todomate/screens/todo/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    // deleteDatabase(path);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('oldversion : $oldVersion , newVersion : $newVersion ');
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
        }
      }
      return null;
    } catch (e) {
      print('Error in getUser: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String loginId, String password) async {
    try {
      await ensurePasswordsAreHashed();
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
        return {"success": false, "message": "아이디 또는 비밀번호가 올바르지 않습니다."};
      }
    } catch (e) {
      return {"success": false, "message": "로그인 중 오류가 발생했습니다: $e"};
    }
  }

  Future<void> printAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users');
    print('All users in database:');
    for (var user in users) {
      var userCopy = Map<String, dynamic>.from(user);
      if (userCopy['password'] != null && userCopy['password'].isNotEmpty) {
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

//////////////////////////////////
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

  Future<String?> getNickname(String loginId) async {
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

  Future<int> updateNickname(String loginId, String newNickname) async {
    Database db = await database;
    return await db.update(
      'users',
      {'nickname': newNickname},
      where: 'login_id = ?',
      whereArgs: [loginId],
    );
  }

  Future<int> deleteUserByLoginId(String loginId) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'login_id = ?',
      whereArgs: [loginId],
    );
  }

//////////////////////////
  Future<void> updatePasswordToHash() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users');
    for (var user in users) {
      if (user['password'].length != 64) {
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

  Future<bool> insertDiary(DiaryDTO diary) async {
    final db = await database;
    try {
      await db.insert('diary', diary.toJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);
      return true;
    } catch (e) {
      print('Insert Database error $e');
      return false;
    }
  }

  Future<List<DiaryDTO>> getDiaryList() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diary',
      columns: ['id', 'userId', 'title', 'description', 'imageUrl', 'createAt'],
    );
    return List<DiaryDTO>.from(
      maps.map((map) => DiaryDTO.fromJson(map)),
    );
  }

  Future<bool> deleteDiary(int id) async {
    try {
      Database db = await database;
      await db.delete(
        'diary',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print('Delete Database error $e');
      return false;
    }
  }

  Future<void> checkTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    for (var table in tables) {
      print('Table: ${table['name']}');
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

  Future<List<Map<String, dynamic>>> searchUsers(
      String query, String userId) async {
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
      throw e;
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
      throw e;
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
      throw e;
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
      throw e;
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
      throw e;
    }
  }
}
