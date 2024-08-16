import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TopicModel {
  int? id;
  String name;
  DateTime? startedAt;
  DateTime? endedAt;

  // 생성자
  TopicModel({
    this.id,
    required this.name,
    this.startedAt,
    this.endedAt,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }
}

class TopicDatabaseHelper {
  static Database? _topicDatabase;

  // 데이터베이스 인스턴스를 가져오거나 새로운 인스턴스를 초기화합니다.
  Future<Database> get database async {
    if (_topicDatabase != null) return _topicDatabase!;
    _topicDatabase = await initDatabase();
    return _topicDatabase!;
  }

  // 데이터베이스를 초기화하고 테이블이 없으면 생성합니다.
  Future<Database> initDatabase() async {
    //  데이터베이스 파일 경로를 얻어옵니다
    String path = join(await getDatabasesPath(), 'topic.db');

    // 지정된 버전 및 생성 콜백으로 데이터베이스를 엽니다.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE topic(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            topicId INTEGER,
            startedAt TEXT,
            endedAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTopicModel(TopicModel chatRoom) async {
    Database db = await database;

    return await db.insert('topic', chatRoom.toMap());
  }

  Future<List<TopicModel>> getChatRoom() async {
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

  Future<void> updateTopicModel(TopicModel chatRoom) async {
    Database db = await database;

    await db.update(
      'topic', // 테이블 이름
      chatRoom.toMap(), // 업데이트할 데이터를 Map 형태로 변환
      where: 'id = ?', // 업데이트할 조건 설정
      whereArgs: [chatRoom.id], // 조건 값 설정
    );
  }

  Future<void> deleteTopicModel(int id) async {
    Database db = await database;

    await db.delete(
      'topic', // 테이블 이름
      where: 'id = ?', // 삭제할 조건 설정
      whereArgs: [id], // 조건 값 설정
    );
  }
}
