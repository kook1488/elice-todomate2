import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todomate/chat/view/chats_screen.dart';
import 'package:todomate/chat/models/user_info.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 여기서 사용자 정보를 가져옵니다 (실제로는 로그인 프로세스나 로컬 스토리지에서 가져올 수 있습니다)
    final userInfo = UserInfo(
      id: 1,
      nickName: '플로터',
      avatarPath: 'assets/images/avata_1.png',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger App',
      theme: ThemeData(fontFamily: 'General Sans'),
      home: ChatsScreen(userInfo: userInfo),
    );
  }
}
