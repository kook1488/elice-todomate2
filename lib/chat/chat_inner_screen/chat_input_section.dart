import 'package:flutter/material.dart';
import 'package:todomate/chat/core/app_export.dart';

class ChatInputSection extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final VoidCallback onSendPressed;
  final VoidCallback onImagePressed;

  const ChatInputSection({
    Key? key,
    required this.messageController,
    required this.focusNode,
    required this.onSendPressed,
    required this.onImagePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 16, right: 16, bottom: 26, top: 3), // 하단 패딩을 26으로 증가
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: ColorConstant.fromHex('#FF642D'),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.add_photo_alternate, color: Colors.white),
                onPressed: onImagePressed,
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSendPressed(),
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: onSendPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
