import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todomate/models/chat_room_model.dart';
import 'package:todomate/models/diary_model.dart';
import 'package:todomate/models/todo_model.dart';
import 'package:todomate/models/topic_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _todoUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  Timer? _reconnectionTimer;

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Stream<Map<String, dynamic>> get todoUpdateStream =>
      _todoUpdateController.stream;

  void connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://172.30.1.57:8080'),
    );
    _channel!.stream.listen(
      (message) {
        print("Received message: $message");
        try {
          final decodedMessage = json.decode(message);
          _todoUpdateController.add(decodedMessage);
        } catch (e) {
          print("Error decoding JSON message: $e");
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
        _scheduleReconnection();
      },
      onDone: () {
        print("WebSocket connection closed");
        _scheduleReconnection();
      },
    );
  }

  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(const Duration(seconds: 5), () {
      print("Attempting to reconnect to WebSocket");
      connectWebSocket();
    });
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
    _reconnectionTimer?.cancel();
  }

  void sendTodoUpdate(String userId, String todoId, bool isCompleted) {
    if (_channel != null) {
      final message = json.encode({
        'type': 'todo_update',
        'userId': userId,
        'todoId': todoId,
        'isCompleted': isCompleted,
      });
      _channel!.sink.add(message);
    }
  }

//on creat 다시 부르는 문제.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
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
          is_friend_completed INTEGER,
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
    await db.execute('''
      CREATE TABLE chat_room(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        topicId INTEGER,
        userId INTEGER,
        startDate TEXT,
        endDate TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE topic(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        startedAt timestamp,
        endedAt timestamp
      )
    ''');
    await db.execute('''
      INSERT INTO topic (name) VALUES ('주제1');
    ''');
    await db.execute('''
      INSERT INTO topic (name) VALUES ('주제2');
    ''');
    await db.execute('''
      INSERT INTO topic (name) VALUES ('주제3');
    ''');
  }

  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   print('oldversion : $oldVersion , newVersion : $newVersion ');
  //   if (oldVersion < 4) {
  //     await db.execute(
  //         'ALTER TABLE todos ADD COLUMN is_friend_completed INTEGER DEFAULT 0');
  //
  //
  //   }
  // }

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
        rethrow;
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

/////kook////////////////////////////////////////////////

  //마이 프로필 열때 업데이트된 정보가져올때 씀
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

//회원 삭제(안쓰고 밑에서를 씀)- login id 안 물고 삭제
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//마이 프로필 열때 처음 닉네임
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

//닉네임 변경
// [3]프로바이더에서 데이터베이스를 호출하여 updateNickname 메서드를 통해 닉네임을 업데이트
// [3]DatabaseHelper 클래스의 updateNickname 메서드는 닉네임을 데이터베이스에 저장
  //이 메서드는 loginId를 기반으로 users 테이블에서 해당 사용자의 닉네임을 새로 입력된 newNickname으로 업데이트
  Future<int> updateNickname(String loginId, String newNickname) async {
    Database db = await database;
    return await db.update(
      'users',
      {'nickname': newNickname},
      where: 'login_id = ?',
      whereArgs: [loginId],
    ); //[4] UI 도 같이 업데이트됨 [2]에서 프로바이더 호출 받을때.
  }

//회원 탈퇴
  Future<int> deleteUserByLoginId(String loginId) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'login_id = ?',
      whereArgs: [loginId],
    );
  }

//kook [2]DB에 메서드 추가
//닉네임 변경시 알림 할려고 밑에 메서드 3개 만듬
// 1닉네임 변경 정보를 저장하는 메서드
  Future<void> saveNicknameChange(
      String loginId, String oldNickname, String newNickname) async {
    final db = await database;
    await db.insert('nickname_changes', {
      'login_id': loginId,
      'oldNickname': oldNickname,
      'newNickname': newNickname,
    });
  }

  // 2친구가 받은 닉네임 변경 정보를 조회하는 메서드
  Future<List<Map<String, dynamic>>> getNicknameChangesForFriend(
      String friendId) async {
    final db = await database;
    return await db.query(
      'nickname_changes',
      where: 'friend_id = ?',
      whereArgs: [friendId],
    );
  }

  // 3 조회된 닉네임 변경 정보를 삭제하는 메서드
  Future<void> clearNicknameChangesForFriend(String friendId) async {
    final db = await database;
    await db.delete(
      'nickname_changes',
      where: 'friend_id = ?',
      whereArgs: [friendId],
    );
  }

////////////////////////////////////////////////////////
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

  Future<List<DiaryDTO>> getDiaryList(String userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diary',
      columns: ['id', 'userId', 'title', 'description', 'imageUrl', 'createAt'],
      where: 'userId = ?',
      whereArgs: [userId],
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

  Future<int> updateDiary(DiaryDTO diary) async {
    try {
      Database db = await database;
      int result = await db.update(
        'diary',
        diary.toJson(),
        where: 'id = ?',
        whereArgs: [diary.id],
      );
      return result;
    } catch (e) {
      print('Update Database error: $e');
      return 0;
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
    return await db.rawQuery('''
    SELECT fr.sender_id, u.nickname
    FROM friend_requests fr
    JOIN users u ON fr.sender_id = u.id
    WHERE fr.receiver_id = ? AND fr.status = ?
  ''', [userId, 'pending']);
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
      rethrow;
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
      rethrow;
    }
  }

  Future<List<Todo>> getTodos(String userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    print('Fetched ${maps.length} todos for user $userId');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> insertTodo(Todo todo) async {
    Database db = await database;
    try {
      await db.insert('todos', todo.toMap());
      print('Inserted new todo: ${todo.id}');
    } catch (e) {
      print('Error inserting todo: $e');
      rethrow;
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
      rethrow;
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
      print('Deleted todo: $todoId');
    } catch (e) {
      print('Error deleting todo: $e');
      rethrow;
    }
  }

  Future<void> updateTodoCompletion(String todoId, bool isCompleted,
      {bool isCurrentUser = true}) async {
    Database db = await database;
    try {
      final updateData = isCurrentUser
          ? {'is_completed': isCompleted ? 1 : 0}
          : {'is_friend_completed': isCompleted ? 1 : 0};

      final rowsAffected = await db.update(
        'todos',
        updateData,
        where: 'id = ?',
        whereArgs: [todoId],
      );

      if (rowsAffected == 0) {
        throw Exception('Todo not found or not updated');
      }

      print(
          'Updated todo completion status: $todoId, isCompleted: $isCompleted, isCurrentUser: $isCurrentUser');
    } catch (e) {
      print('Error updating todo completion status: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAcceptedFriends(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT DISTINCT u.id, u.nickname 
    FROM users u
    JOIN friend_requests fr ON (fr.sender_id = u.id OR fr.receiver_id = u.id)
    WHERE ((fr.sender_id = ? AND fr.receiver_id = u.id) 
       OR (fr.receiver_id = ? AND fr.sender_id = u.id))
    AND fr.status = 'accepted' 
    AND u.id != ?
  ''', [userId, userId, userId]);
    return maps;
  }

  Future<Todo?> getLinkedTodo(String userId, String originalTodoId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, originalTodoId],
    );

    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateLinkedTodo(
      String userId, String originalTodoId, bool isCompleted) async {
    final db = await database;
    try {
      final rowsAffected = await db.update(
        'todos',
        {'is_friend_completed': isCompleted ? 1 : 0},
        where: 'user_id = ? AND friend_id = ?',
        whereArgs: [userId, originalTodoId],
      );

      if (rowsAffected == 0) {
        throw Exception('Linked todo not found or not updated');
      }

      print(
          'Updated linked todo completion status for user $userId and original todo $originalTodoId');
    } catch (e) {
      print('Error updating linked todo: $e');
      rethrow;
    }
  }

  // 디버깅을 위한 메서드
  Future<void> printAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    print('All todos in database:');
    for (var todo in maps) {
      print(todo);
    }
  }

  // 웹소켓 연결 상태 확인
  bool isWebSocketConnected() {
    return _channel != null;
  }

  // chat_room
  Future<int> insertChatRoomModel(ChatRoomModel chatRoom) async {
    Database db = await database;

    // 테이블에 데이터를 삽입하고 삽입된 ID를 반환합니다.
    return await db.insert('chat_room', chatRoom.toMap());
  }

  Future<List<ChatRoomModel>> getChatRoom(List<int> filterList) async {
    Database db = await database;
    String topicListFilter =
        'select * from chat_room where topicId in (${filterList.join(',')}) order by id desc;';

    if (filterList.isEmpty) {
      topicListFilter = 'select * from chat_room order by id desc;';
    }
    // print(filterList);

    // 테이블에서 모든 행을 쿼리합니다.
    List<Map<String, dynamic>> maps = await db.rawQuery(topicListFilter);
    // List<Map<String, dynamic>> maps = await db.query(
    //   'chat_room',
    //   where: 'topicId in ?',
    //   whereArgs: [(1)],
    //   orderBy: 'id desc',
    // );

    // 쿼리 결과에서 객체의 목록을 생성합니다.
    return List.generate(maps.length, (index) {
      return ChatRoomModel(
        id: maps[index]['id'],
        name: maps[index]['name'],
        topicId: maps[index]['topicId'],
        userId: maps[index]['userId'],
        startDate: maps[index]['startDate'],
        endDate: maps[index]['endDate'],
      );
    });
  }

  Future<ChatRoomModel> getChatRoomDetail(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'chat_room',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    final map = ChatRoomModel(
      id: maps.first['id'],
      name: maps.first['name'],
      topicId: maps.first['topicId'],
      userId: maps.first['userId'],
      startDate: maps.first['startDate'],
      endDate: maps.first['endDate'],
    );
    return map;
  }

  Future<void> updateChatRoomModel(ChatRoomModel chatRoom) async {
    Database db = await database;

    await db.update(
      'chat_room', // 테이블 이름
      chatRoom.toMap(), // 업데이트할 데이터를 Map 형태로 변환
      where: 'id = ?', // 업데이트할 조건 설정
      whereArgs: [chatRoom.id], // 조건 값 설정
    );
  }

  Future<void> deleteChatRoomModel(int id) async {
    Database db = await database;

    await db.delete(
      'chat_room', // 테이블 이름
      where: 'id = ?', // 삭제할 조건 설정
      whereArgs: [id], // 조건 값 설정
    );
  }

  // topic
  Future<int> insertTopicModel(TopicModel topic) async {
    Database db = await database;

    return await db.insert('topic', topic.toMap());
  }

  Future<List<TopicModel>> getTopic() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'topic',
      orderBy: 'id desc',
    );

    return List.generate(maps.length, (index) {
      return TopicModel(
        id: maps[index]['id'],
        name: maps[index]['name'],
        startedAt: maps[index]['startedAt'],
        endedAt: maps[index]['endedAt'],
      );
    });
  }

  Future<TopicModel> getTopicDetail({required int topicId}) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'chat_room',
      where: 'id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    final map = TopicModel(
      id: maps.first['id'],
      name: maps.first['name'],
    );
    return map;
  }

  Future<String> getTopicDetailName({required int topicId}) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'topic',
      where: 'id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    return maps.first['name'];
  }

  Future<void> updateTopicModel(TopicModel topic) async {
    Database db = await database;

    await db.update(
      'topic', // 테이블 이름
      topic.toMap(), // 업데이트할 데이터를 Map 형태로 변환
      where: 'id = ?', // 업데이트할 조건 설정
      whereArgs: [topic.id], // 조건 값 설정
    );
  }

  Future<void> deleteTopicModel(TopicModel topic) async {
    Database db = await database;

    await db.delete(
      'topic', // 테이블 이름
      where: 'id = ?', // 삭제할 조건 설정
      whereArgs: [topic.id], // 조건 값 설정
    );
  }

  // 웹소켓 재연결
  void reconnectWebSocket() {
    disconnectWebSocket();
    connectWebSocket();
  }

  // 리소스 정리
  void dispose() {
    disconnectWebSocket();
    _todoUpdateController.close();
  }

  Future<List<String>> getFriendIds(String loginId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'friend_requests',
      columns: ['sender_id', 'receiver_id'],
      where: '(sender_id = ? OR receiver_id = ?) AND status = ?',
      whereArgs: [loginId, loginId, 'accepted'],
    );

    List<String> friendIds = [];

    for (var map in maps) {
      if (map['sender_id'] != loginId) {
        friendIds.add(map['sender_id'] as String);
      } else if (map['receiver_id'] != loginId) {
        friendIds.add(map['receiver_id'] as String);
      }
    }

    return friendIds;
  }
}
