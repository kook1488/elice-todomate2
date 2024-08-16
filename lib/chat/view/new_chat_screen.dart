import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todomate/chat/core/app_export.dart';
import 'package:todomate/chat/models/user_info.dart';
import 'package:todomate/chat/view/chat_inner_screen.dart';
import 'package:todomate/chat/models/chat_model.dart';

class NewChatScreen extends StatelessWidget {
  final UserInfo userInfo;

  NewChatScreen({Key? key, required this.userInfo}) : super(key: key);

  final List<Map<String, dynamic>> contacts = [
    {"id": 1, "name": "Alice", "image": "assets/images/avata_a.png"},
    {"id": 2, "name": "Bob", "image": "assets/images/avata_b.png"},
    {"id": 3, "name": "Charlie", "image": "assets/images/avata_c.png"},
    // 더 많은 연락처 추가...
  ];

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
                    "새 채팅",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.whiteA700,
                      fontSize: getFontSize(34),
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: ColorConstant.whiteA700),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return InkWell(
                    onTap: () {
                      final newChat = ChatModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: "Chat with ${contact["name"]}",
                        name: contact["name"],
                        image: contact["image"],
                        lastMessage: "",
                        date: DateTime.now(),
                        unread: 0,
                      );
                      
                      // 새 채팅 저장 (실제 구현에서는 DB에 저장해야 함)
                      // DatabaseHelper.instance.insertChat(newChat);
                      
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
                    child: Container(
                      margin: EdgeInsets.only(
                        top: getVerticalSize(6.0),
                        bottom: getVerticalSize(6.0),
                      ),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ColorConstant.whiteA700,
                        borderRadius: BorderRadius.circular(
                          getHorizontalSize(12),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            contact["image"],
                            height: getSize(64),
                            width: getSize(64),
                            fit: BoxFit.cover,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              contact["name"],
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.gray900,
                                fontSize: getFontSize(16),
                                fontFamily: 'General Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}