import 'package:flutter/material.dart';
import 'package:todomate/chat/core/app_export.dart';
import 'package:todomate/chat/models/user_info.dart';
import 'package:todomate/chat/view/chat_inner_screen.dart';
import 'package:todomate/chat/models/chat_model.dart';

class NewChatScreen extends StatelessWidget {
  final UserInfo userInfo;

  NewChatScreen({Key? key, required this.userInfo}) : super(key: key);

  final List<Map<String, dynamic>> contacts = [
    {"id": 1, "name": "Alice", "avatar": "assets/images/img_avatar_alice.png"},
    {"id": 2, "name": "Bob", "avatar": "assets/images/img_avatar_bob.png"},
    {"id": 3, "name": "Charlie", "avatar": "assets/images/img_avatar_charlie.png"},
    // 더 많은 연락처 추가...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새 채팅"),
        backgroundColor: ColorConstant.fromHex('#FF642D'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(contact["avatar"]),
            ),
            title: Text(contact["name"]),
            onTap: () {
              // 새 채팅 모델 생성
              final newChat = ChatModel(
                id: DateTime.now().millisecondsSinceEpoch,
                title: "Chat with ${contact["name"]}",
                name: contact["name"],
                image: contact["avatar"],
                lastMessage: "",
                date: DateTime.now(),
                unread: 0,
              );
              
              // 새 채팅 저장 (실제 구현에서는 DB에 저장해야 함)
              // DatabaseHelper.instance.insertChat(newChat);
              
              // 채팅 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatInnerScreen(
                    jsonFileName: 'chat_${newChat.id}.json',
                    chatTitle: newChat.title,
                    otherAvatarPath: newChat.image,
                    chatId: newChat.id,
                    userInfo: userInfo,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}