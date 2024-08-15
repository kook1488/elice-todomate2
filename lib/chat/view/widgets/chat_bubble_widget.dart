import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String otherAvatarPath;

  const ChatBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.otherAvatarPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (isMe ? Alignment.topRight : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (isMe ? Colors.blue[200] : Colors.grey[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}