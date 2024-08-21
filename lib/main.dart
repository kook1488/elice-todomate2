import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/account/introscreen.dart';
import 'package:todomate/screens/diary/diary_provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/todo/todo_provider.dart';

void main() {
  initializeDateFormatting().then((_) {
    runApp(
      MultiProvider(
        providers: [
          // 여기에 다른 provider들을 추가할 수 있습니다.
          ChangeNotifierProvider(create: (context) => TodoProvider()),
          ChangeNotifierProvider(create: (context) => DiaryProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todomate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroScreen(),
    );
  }
}
