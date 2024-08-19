// import 'package:mysql1/mysql1.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:todomate/chat/models/user_info.dart';
// import 'package:todomate/chat/models/chat_model.dart';
// import 'package:todomate/chat/models/message_model.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static MySqlConnection? _connection;
//
//   DatabaseHelper._init();
//
//   Future<MySqlConnection> get connection async {
//     if (_connection != null) return _connection!;
//     _connection = await _initConnection();
//     return _connection!;
//   }
//
//   Future<MySqlConnection> _initConnection() async {
//     try {
//       var settings = ConnectionSettings(
//         host: 'localhost',
//         port: 3306,
//         user: 'username',
//         password: 'password',
//         db: 'chat_database',
//       );
//       final conn = await MySqlConnection.connect(settings);
//       await _createTables(conn);
//       return conn;
//     } catch (e) {
//       print('Error connecting to the database: $e');
//       rethrow; // rethrow the error after logging
//     }
//   }
//
//   Future<void> _createTables(MySqlConnection conn) async {
//     final tableQueries = [
//       UserInfo.createTableQuery,
//       ChatModel.createTableQuery,
//       MessageModel.createTableQuery,
//     ];
//
//     for (var query in tableQueries) {
//       try {
//         await conn.query(query);
//       } catch (e) {
//         print('Error creating table: $e');
//       }
//     }
//   }
//
//   Future<UserInfo?> getUser(int id) async {
//     try {
//       final conn = await connection;
//       var result = await conn.query('SELECT * FROM users WHERE id = ?', [id]);
//       if (result.isNotEmpty) {
//         return UserInfo.fromMap(result.first.fields);
//       }
//     } catch (e) {
//       print('Error fetching user: $e');
//     }
//     return null;
//   }
//
//   Future<int> insertUser(UserInfo user) async {
//     try {
//       final conn = await connection;
//       var result = await conn.query(
//         'INSERT INTO users (name, email) VALUES (?, ?)',
//         [user.name, user.email],
//       );
//       return result.insertId!;
//     } catch (e) {
//       print('Error inserting user: $e');
//       return -1; // indicate an error with a negative ID
//     }
//   }
//
//   Future<List<ChatModel>> getAllChats() async {
//     try {
//       final conn = await connection;
//       var result = await conn.query('SELECT * FROM chats');
//       return result.map((row) => ChatModel.fromMap(row.fields)).toList();
//     } catch (e) {
//       print('Error fetching chats: $e');
//       return [];
//     }
//   }
//
//   Future<int> insertChat(ChatModel chat) async {
//     try {
//       final conn = await connection;
//       var result = await conn.query(
//         'INSERT INTO chats (user1, user2, lastMessage) VALUES (?, ?, ?)',
//         [chat.user1, chat.user2, chat.lastMessage],
//       );
//       return result.insertId!;
//     } catch (e) {
//       print('Error inserting chat: $e');
//       return -1;
//     }
//   }
//
//   Future<int> insertMessage(MessageModel message) async {
//     try {
//       final conn = await connection;
//       var result = await conn.query(
//         'INSERT INTO messages (chatId, senderId, message, timestamp, isRead) VALUES (?, ?, ?, ?, ?)',
//         [
//           message.chatId,
//           message.senderId,
//           message.message,
//           message.timestamp,
//           message.isRead ? 1 : 0
//         ],
//       );
//       return result.insertId!;
//     } catch (e) {
//       print('Error inserting message: $e');
//       return -1;
//     }
//   }
//
//   Future<int> markMessageAsRead(int messageId) async {
//     try {
//       final conn = await connection;
//       var result = await conn.query(
//         'UPDATE messages SET isRead = 1 WHERE id = ?',
//         [messageId],
//       );
//       return result.affectedRows;
//     } catch (e) {
//       print('Error marking message as read: $e');
//       return -1;
//     }
//   }
//
//   Future<void> closeConnection() async {
//     if (_connection != null) {
//       await _connection!.close();
//       _connection = null;
//     }
//   }
// }
//
// class WebSocketHelper {
//   static final WebSocketHelper instance = WebSocketHelper._init();
//   WebSocketChannel? _channel;
//   bool _isConnected = false;
//
//   WebSocketHelper._init();
//
//   void connect(String url) {
//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(url));
//       _isConnected = true;
//       _channel?.stream.listen((message) {
//         print('Received: $message');
//       }, onError: (error) {
//         print('WebSocket error: $error');
//         _isConnected = false;
//       }, onDone: () {
//         print('WebSocket connection closed.');
//         _isConnected = false;
//         _reconnect(url);
//       });
//     } catch (e) {
//       print('Error connecting to WebSocket: $e');
//     }
//   }
//
//   void sendMessage(String message) {
//     if (_isConnected) {
//       _channel?.sink.add(message);
//     } else {
//       print('WebSocket is not connected. Message not sent.');
//     }
//   }
//
//   void disconnect() {
//     _channel?.sink.close();
//     _isConnected = false;
//   }
//
//   void _reconnect(String url) {
//     if (!_isConnected) {
//       print('Reconnecting to WebSocket...');
//       connect(url);
//     }
//   }
// }
