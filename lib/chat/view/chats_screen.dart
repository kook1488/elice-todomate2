import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';
import 'package:todomate/chat/models/chat_model.dart';
import 'package:todomate/chat/view/chat_inner_screen.dart';
import 'package:todomate/screens/chat_room/chat_room_detail.dart';
import 'package:todomate/screens/chat_room/test_models.dart';
import 'package:todomate/screens/diary/diary.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/todo/todo_list_screen.dart';

import '../models/user_info.dart';
import 'widgets/chats_item_widget.dart';

class ChatsScreen extends StatefulWidget {
  final UserInfo userInfo;


  const ChatsScreen({Key? key, required this.userInfo}) : super(key: key);


  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with ScrollControllerMixin {
  final StreamController<List<ChatModel>> _chatListController =
      StreamController<List<ChatModel>>.broadcast();
  List<ChatModel> _chatList = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  @override
  void dispose() {
    _chatListController.close();
    super.dispose();
  }

  void loadChats() async {
    try {
      // 채팅 데이터 로드 (실제 구현 필요)
      _chatList = []; // 실제 데이터 로딩 로직으로 대체
      _chatListController.add(_chatList);
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTop());
    } catch (e) {
      print("채팅 로드 실패: $e");
    }
  }

  void updateChatList(ChatModel newChat) {
    setState(() {
      _chatList.add(newChat);
      _chatList.sort((a, b) => b.date.compareTo(a.date));
      _chatListController.add(_chatList);
    });
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // userInfo에서 loginId 가져오기
    String loginId = widget.userInfo.loginId; // loginId 변수 선언 및 초기화 //*

    List<Widget> _pages = [
      _buildChatList(),
      TodoListScreen(userId: widget.userInfo.id.toString()),
      DiaryCalendarScreen(),
      ProfileScreen(loginId: loginId) //required로 필수로 지정하다보니
    ];
    //프로필 스크린으로 가는 와중에 위젯문제로 에러가 난다
    //아이디 삭제는 따로 잘되는거 같다 페이지 이동에 문제가 있을 뿐

    return Scaffold(
      appBar: AppBar(
        title: Text("채팅방 리스트"),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () async {
          final newChat = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomDetailScreen(chatRoomDetail: ChatRoomModel(name: 'name', topicId: 1, userId: 2, startDate: 'startDate', endDate: 'endDate')),
            ),
          );
          if (newChat != null) {
            updateChatList(newChat);
          }
        },
        backgroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  Widget _buildChatList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.orange,
            Colors.orange,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 71,
              left: 16,
              right: 16,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: _chatListController.stream,
              initialData: _chatList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("채팅이 없습니다."));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                }

                final chats = snapshot.data ?? [];
                if (chats.isEmpty) {
                  return Center(child: Text('채팅이 없습니다.'));
                }

                return ListView.builder(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatInnerScreen(
                            jsonFileName: 'chat_${chat.id}.json',
                            chatTitle: chat.title,
                            otherAvatarPath: chat.image,
                            chatId: chat.id,
                            userInfo: widget.userInfo,
                          ),
                        ),
                      ),
                      child: ChatsItemWidget(chat),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}