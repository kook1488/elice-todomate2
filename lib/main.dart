import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/account/introscreen.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';
import 'package:todomate/screens/diary/diary_provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/todo/todo_provider.dart';
import 'package:todomate/util/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.initialize();
  initializeDateFormatting().then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TodoProvider()),
          ChangeNotifierProvider(create: (context) => DiaryProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider()),
          ChangeNotifierProvider(create: (context) => ChatRoomProvider()),
          // WebSocketService를 제공자로 추가합니다.
          // Provider(create: (context) => WebSocketService()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // WebSocketService 인스턴스를 가져옵니다.
    // final webSocketService =
    //     Provider.of<WebSocketService>(context, listen: false);
    //
    // // WebSocket 연결을 설정합니다.
    // webSocketService.onMessageReceived = (Map<String, dynamic> message) {
    //   // 수신된 메시지를 처리하는 코드
    //   print('Message received: $message');
    // };
    //
    // webSocketService.onError = (String error) {
    //   // 오류 처리 코드
    //   print('Error: $error');
    // };
    //
    // // WebSocket 서버에 연결합니다.
    // webSocketService.connect('ws://172.30.1.57:8080'); // 실제 WebSocket URL로 변경

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todomate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroScreen(),
    );
  }
}
