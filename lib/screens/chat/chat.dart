import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> chats = [];

  void _addChat(String chat) {
    chats.add(chat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('채팅'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 700,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 14,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final isMine = index % 2 == 0;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            for (String c in chats)
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft:
                                        Radius.circular(isMine ? 20 : 5),
                                    bottomRight:
                                        Radius.circular(!isMine ? 20 : 5),
                                  ),
                                ),
                                child: Text(
                                  c,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 텍스트 필드
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: ' Send a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _addChat('fffff'),
                          child: const Text('전송'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
