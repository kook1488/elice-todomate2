import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';
import 'package:todomate/chat/models/chat_model.dart';
import 'package:todomate/chat/view/chat_inner_screen.dart';
import 'package:todomate/screens/chat_room/chat_room.dart';
import 'package:todomate/screens/diary/diary.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/todo/todo_list_screen.dart';
import 'package:todomate/util/sharedpreference.dart';

// 매개변수 값 안넣고 하는거 쉐어드 프리퍼랜스
// 로그인 스크린에서 로그인 아이디 없이 디비 조회 할 것인데
// 어떻게 할것인가? -쉐어드 프리퍼렌스
import '../models/user_info.dart';
import 'widgets/chats_item_widget.dart';

class ChatsScreen extends StatefulWidget {
  final UserInfo userInfo;

  const ChatsScreen({super.key, required this.userInfo});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with ScrollControllerMixin {
  final StreamController<List<ChatModel>> _chatListController =
      StreamController<List<ChatModel>>.broadcast();
  List<ChatModel> _chatList = [];
  int _selectedIndex = 0;
  String _id = '';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    loadChats();
    getUserInfo();
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

    List<Widget> pages = [
      // _buildChatList(),
      const ChatRoomScreen(),
      TodoListScreen(userId: widget.userInfo.id.toString()),
      const DiaryCalendarScreen(),
      ProfileScreen(loginId: _userId) //required로 필수로 지정하다보니
    ];
    //프로필 스크린으로 가는 와중에 위젯문제로 에러가 난다
    //아이디 삭제는 따로 잘되는거 같다 페이지 이동에 문제가 있을 뿐

    return Scaffold(
      body: pages[_selectedIndex],
      // floatingActionButton: _selectedIndex == 0
      //     ? FloatingActionButton(
      //         onPressed: () async {
      //           final newChat = await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => ChatDetailScreen(userInfo: widget.userInfo),
      //             ),
      //           );
      //           if (newChat != null) {
      //             updateChatList(newChat);
      //           }
      //         },
      //         backgroundColor: Colors.white,
      //         elevation: 2,
      //         child: const Icon(Icons.add),
      //       )
      //     : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
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
      decoration: const BoxDecoration(
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
            margin: const EdgeInsets.only(
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
                  return const Center(child: Text('채팅이 없습니다.'));
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

  Widget _buildNotifications() {
    return const Center(child: Text('다이어리'));
  }

  Widget _buildAccount() {
    return const Center(child: Text('마이페이지'));
  }

  //dodo sharedpreference에서 가져오기
  Future<void> getUserInfo() async {
    final userId = await TodoSharedPreference().getPreferenceWithKey('userId');
    final id = await TodoSharedPreference().getPreferenceWithKey('id');

    setState(() {
      _userId = userId;
      _id = id;
    });
  }
}
