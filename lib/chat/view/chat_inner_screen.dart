import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todomate/chat/core/app_export.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';
import 'package:todomate/chat/models/message_model.dart';
import 'package:todomate/chat/models/user_info.dart';
import 'package:todomate/chat/view/chat_input_section.dart';
import 'package:todomate/chat/view/widgets/chat_inner_item_widget.dart';

class ChatInnerScreen extends StatefulWidget {
  final String jsonFileName;
  final String chatTitle;
  final String otherAvatarPath;
  final int chatId;
  final UserInfo userInfo;

  const ChatInnerScreen({
    super.key,
    required this.jsonFileName,
    required this.chatTitle,
    required this.otherAvatarPath,
    required this.chatId,
    required this.userInfo,
  });

  @override
  _ChatInnerScreenState createState() => _ChatInnerScreenState();
}

class _ChatInnerScreenState extends State<ChatInnerScreen>
    with ScrollControllerMixin {
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> messages = [];
  final picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    scrollController = _scrollController; // Set the scrollController
    loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMessages() async {
    try {
      print('Loading file: ${widget.jsonFileName}');
      final String response =
      await rootBundle.loadString('assets/${widget.jsonFileName}');
      final List<dynamic> data = await json.decode(response);
      setState(() {
        messages = data.map((item) => MessageModel.fromJson(item)).toList();
      });
      scrollToBottom();
    } catch (e) {
      print('Error loading chat data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages. Please try again.')),
      );
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        messages.add(MessageModel(
          id: messages.length + 1,
          sender: widget.userInfo.nickName,
          userId: widget.userInfo.id,
          message: '', // Use an empty string instead of null
          avatarImage: widget.userInfo.avatarPath,
          attachedImage: pickedFile.path,
          timestamp: DateTime.now(),
          read: false,
        ));
      });
      scrollToBottom();
    } else {
      print('No image selected.');
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(MessageModel(
          id: messages.length + 1,
          sender: widget.userInfo.nickName,
          userId: widget.userInfo.id,
          message: _messageController.text, // Use the actual message
          avatarImage: widget.userInfo.avatarPath,
          attachedImage: null,
          timestamp: DateTime.now(),
          read: false,
        ));
        _messageController.clear();
      });
      scrollToBottom();
    }
    FocusScope.of(context).requestFocus(_focusNode);
  }

  String _formatDate(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true;
    final currentDate = messages[index].timestamp;
    final previousDate = messages[index - 1].timestamp;
    return !currentDate.isSameDate(previousDate);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);  // Allow the back navigation
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            toolbarHeight: 110,
            backgroundColor: ColorConstant.fromHex('#FF642D'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.otherAvatarPath),
                  radius: 45,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.chatTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            titleSpacing: 20,
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool isUserMessage = message.userId == widget.userInfo.id;

                  return Column(
                    children: [
                      if (_shouldShowDateSeparator(index))
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(message.timestamp),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                      if (!isUserMessage)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
                            child: Text(
                              message.sender,
                              style: const TextStyle(
                                color: Color(0xffff642d),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: isUserMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUserMessage)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    message.avatarImage ?? widget.otherAvatarPath),
                                radius: 20,
                              ),
                            ),
                          Expanded(
                            child: ChatInnerItemWidget(
                              isRight: isUserMessage,
                              highlight: false,
                              message: message,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                    ],
                  );
                },
              ),
            ),
            ChatInputSection(
              messageController: _messageController,
              focusNode: _focusNode,
              onSendPressed: _sendMessage,
              onImagePressed: getImage,
            ),
          ],
        ),
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
