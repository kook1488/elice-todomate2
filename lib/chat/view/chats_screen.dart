import 'package:flutter/material.dart';
import 'package:todomate/chat/models/chat_model.dart';
import 'package:todomate/screens/chat_room/chat_room.dart';
import 'package:todomate/screens/diary/diary.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/todo/todo_list_screen.dart';
import '../models/user_info.dart';

class ChatsScreen extends StatefulWidget {
  final UserInfo userInfo;

  const ChatsScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;
  List<ChatModel> _chatList = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  void loadChats() async {
    try {
      // TODO: 실제 채팅 데이터 로드 로직 구현
      _chatList = []; // 예시: 빈 리스트로 초기화
      setState(() {}); // 상태 업데이트
    } catch (e) {
      print("채팅 로드 실패: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      ChatRoomScreen(),
      TodoListScreen(userId: widget.userInfo.id.toString()),
      DiaryCalendarScreen(),
      ProfileScreen(loginId: '',)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("채팅방 리스트"),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '투두리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '다이어리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}