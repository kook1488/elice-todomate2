import 'package:mysql1/mysql1.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:todomate/chat/models/user_info.dart';
import 'package:todomate/chat/models/chat_model.dart';
import 'package:todomate/chat/models/message_model.dart';

// DB 와 Websoket 연동 준비를 위한 부분..

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static MySqlConnection? _connection;

  DatabaseHelper._init();

  Future<MySqlConnection> get connection async {
    if (_connection != null) return _connection!;
    _connection = await _initConnection();
    return _connection!;
  }

  Future<MySqlConnection> _initConnection() async {
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'username',
      password: 'password',
      db: 'chat_database',
    );

    final conn = await MySqlConnection.connect(settings);
    await _createTables(conn);
    return conn;
  }

  Future<void> _createTables(MySqlConnection conn) async {
    final tableQueries = [
      UserInfo.createTableQuery,
      ChatModel.createTableQuery,
      MessageModel.createTableQuery,
    ];

    for (var query in tableQueries) {
      await conn.query(query);
    }
  }

  // Example methods for CRUD operations on each model
  Future<UserInfo?> getUser(int id) async {
    final conn = await connection;
    var result = await conn.query('SELECT * FROM users WHERE id = ?', [id]);
    if (result.isNotEmpty) {
      return UserInfo.fromMap(result.first.fields);
    }
    return null;
  }

  Future<int> insertUser(UserInfo user) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO users (name, email) VALUES (?, ?)',
      [user.name, user.email],
    );
    return result.insertId!;
  }

  Future<List<ChatModel>> getAllChats() async {
    final conn = await connection;
    var result = await conn.query('SELECT * FROM chats');
    return result.map((row) => ChatModel.fromMap(row.fields)).toList();
  }

  Future<int> insertChat(ChatModel chat) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO chats (user1, user2, lastMessage) VALUES (?, ?, ?)',
      [chat.user1, chat.user2, chat.lastMessage],
    );
    return result.insertId!;
  }

  Future<int> insertMessage(MessageModel message) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO messages (chatId, senderId, message, timestamp, isRead) VALUES (?, ?, ?, ?, ?)',
      [
        message.chatId,
        message.senderId,
        message.message,
        message.timestamp,
        message.isRead ? 1 : 0
      ],
    );
    return result.insertId!;
  }

  Future<int> markMessageAsRead(int messageId) async {
    final conn = await connection;
    var result = await conn.query(
      'UPDATE messages SET isRead = 1 WHERE id = ?',
      [messageId],
    );
    return result.affectedRows;
  }
}

class WebSocketHelper {
  static final WebSocketHelper instance = WebSocketHelper._init();
  WebSocketChannel? _channel;

  WebSocketHelper._init();

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen((message) {
      print('Received: $message');
    });
  }

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
