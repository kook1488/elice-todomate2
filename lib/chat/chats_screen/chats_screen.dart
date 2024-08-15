import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:todomate/chat/core/app_export.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';
import '../models/chat_model.dart';
import 'widgets/chats_item_widget.dart';
import 'package:todomate/chat/chat_inner_screen/chat_inner_screen.dart';
import 'package:todomate/chat/models/user_info.dart';

class ChatsScreen extends StatefulWidget {
  final UserInfo userInfo;

  const ChatsScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with ScrollControllerMixin {
  final StreamController<List<ChatModel>> _chatListController = StreamController<List<ChatModel>>.broadcast();
  List<ChatModel> _chatList = [];

  @override
  void initState() {
    super.initState();
    loadChats();
    //
    // 향후 WebSocket 연결을 위한 메서드 호출
    /* 
    connectToWebSocket();
    */
  }

  @override
  void dispose() {
    _chatListController.close();
    //
    // 향후 WebSocket 연결 해제를 위한 메서드 호출
    /* 
    disconnectWebSocket();
    */
    super.dispose();
  }

  void loadChats() async {
    // 현재는 로컬 데이터를 사용합니다.
    _chatList = itemsList.map((item) => ChatModel.fromJson(item)).toList();
    _chatList.sort((a, b) => b.date.compareTo(a.date));
    _chatListController.add(_chatList);
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTop());
    //
    //향후 DB에서 데이터를 가져오도록 변경해야 합니다. 예시:
    /* 
    
    try {
      final dbHelper = DatabaseHelper.instance;
      _chatList = await dbHelper.getAllChats();
      _chatList.sort((a, b) => b.date.compareTo(a.date));
      _chatListController.add(_chatList);
    } catch (e) {
      print('Error loading chats from DB: $e');
      // 에러 처리 로직 추가 필요
    }
    */
  }

  //
  //향후 WebSocket 연결 및 메시지 처리를 위한 메서드
  /* 
  void connectToWebSocket() {
    WebSocketHelper.instance.connect('ws://your-websocket-url');
    WebSocketHelper.instance.onMessage((data) {
      updateChatList(data);
    });
  }

  void disconnectWebSocket() {
    WebSocketHelper.instance.disconnect();
  }
  */

  // 실시간 업데이트를 위한 메서드
  void updateChatList(Map<String, dynamic> data) {
    int chatId = data['chatId'];
    int unreadCount = data['unreadCount'];
    
    int index = _chatList.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chatList[index] = _chatList[index].copyWith(unread: unreadCount);
      _chatList.sort((a, b) => b.date.compareTo(a.date));
      _chatListController.add(_chatList);
    }
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorConstant.fromHex('#FF642D'),
              ColorConstant.fromHex('#FF642D'),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: getVerticalSize(71),
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "채팅",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.whiteA700,
                      fontSize: getFontSize(34),
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: _chatListController.stream,
                initialData: _chatList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatInnerScreen(
                                jsonFileName: 'chat_${snapshot.data![index].id}.json',
                                chatTitle: snapshot.data![index].title,
                                otherAvatarPath: snapshot.data![index].image,
                                chatId: snapshot.data![index].id,
                                userInfo: widget.userInfo,
                              ),
                            ),
                          ),
                          child: ChatsItemWidget(snapshot.data![index]),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          height: getVerticalSize(83),
          width: MediaQuery.of(context).size.width,
          color: ColorConstant.whiteA700E5,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: getVerticalSize(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ImageConstant.imgIcon1,
                  ImageConstant.imgIcon,
                  ImageConstant.imgIcon3,
                ]
                    .map<Widget>((icon) => SizedBox(
                          height: getSize(26),
                          width: getSize(24),
                          child: SvgPicture.asset(
                            icon,
                            fit: BoxFit.fill,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}