import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';

class ChatScreenTest extends StatefulWidget {
  final String roomId;
  const ChatScreenTest({super.key, required this.roomId});

  @override
  State<ChatScreenTest> createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest> with ScrollControllerMixin{
  late Socket socket; // 별칭 없이 직접 사용
  late TextEditingController _messageController;
  List<ChatDTO> chats = [];

  void _addChat(ChatDTO chat) {
    setState(() {
      chats.add(chat);
    });
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();

    _connectSocket();
  }

  void _connectSocket() {
    //IP등록
    socket = io('http://192.168.200.165:3000', <String, dynamic>{
      'transports': ['websocket'],
    });



    socket.on('connect', (_) {
      print('Connected to server');
      //roomId로 룸 가입
      socket.emit('joinRoom',widget.roomId);
    });


    socket.on('receiveMessage', (message) {
      print('$message');
      setState(() {
        _messages.add(message);
        scrollToBottom();
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      //emit할때 배열로 인자 2개(message,roomId) 안 넣으면 receiveMessage가 안옴 -> 룸안에 있는 사람에게 전역으로 revicemessage를 주기 때문
      socket.emit('sendMessage', [_messageController.text , widget.roomId]);
      _messageController.clear();
    }
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
            // ListView를 Expanded로 감싸서 남은 공간을 차지하도록 함
            Expanded(
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
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.blue
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isMine ? 20 : 5),
                            bottomRight: Radius.circular(!isMine ? 20 : 5),
                          ),
                        ),
                        child: Text(
                          chats[index],
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
            // 텍스트 필드와 전송 버튼
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
                      controller: _messageController,
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
                    onPressed: () =>{
                      _addChat('fffff'),
                      _messageController.clear()
                    },
                    child: const Text('전송'),
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

class ChatDTO{
  String id;
  String message;

  ChatDTO({required this.id, required this.message});
}
