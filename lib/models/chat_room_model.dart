import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatRoomModel {
  int? id;
  String name;
  int topicId;
  String startDate;
  String endDate;

  // 생성자
  ChatRoomModel({
    this.id,
    required this.name,
    required this.topicId,
    required this.startDate,
    required this.endDate,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topicId': topicId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class ChatRoomDatabaseHelper {
  static Database? _chatRoomDatabase;

  // 데이터베이스 인스턴스를 가져오거나 새로운 인스턴스를 초기화합니다.
  Future<Database> get database async {
    if (_chatRoomDatabase != null) return _chatRoomDatabase!;
    _chatRoomDatabase = await initDatabase();
    return _chatRoomDatabase!;
  }

  // 데이터베이스를 초기화하고 테이블이 없으면 생성합니다.
  Future<Database> initDatabase() async {
    //  데이터베이스 파일 경로를 얻어옵니다 ('chat_room.db').
    String path = join(await getDatabasesPath(), 'chat_room.db');

    // 지정된 버전 및 생성 콜백으로 데이터베이스를 엽니다.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 테이블을 생성하는 SQL 쿼리를 실행합니다.
        await db.execute('''
          CREATE TABLE chat_room(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            topicId INTEGER,
            startDate TEXT,
            endDate TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertChatRoomModel(ChatRoomModel chatRoom) async {
    Database db = await database;

    // 테이블에 데이터를 삽입하고 삽입된 ID를 반환합니다.
    return await db.insert('chat_room', chatRoom.toMap());
  }

  Future<List<ChatRoomModel>> getChatRoom() async {
    Database db = await database;

    // 테이블에서 모든 행을 쿼리합니다.
    List<Map<String, dynamic>> maps = await db.query(
      'chat_room',
      orderBy: 'id desc',
    );

    // 쿼리 결과에서 객체의 목록을 생성합니다.
    return List.generate(maps.length, (index) {
      return ChatRoomModel(
        id: maps[index]['id'],
        name: maps[index]['name'],
        topicId: maps[index]['topicId'],
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
}
