import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';

class ChatScreenTest extends StatefulWidget {
  final String roomId;
  const ChatScreenTest({super.key, required this.roomId});

  @override
  State<ChatScreenTest> createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest> with ScrollControlMixin{
  late Socket socket; // 별칭 없이 직접 사용
  late TextEditingController _messageController;
  List<ChatDTO> chats = [];
  String _socketId = '';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();

    _connectSocket();
  }

  void _connectSocket() {
    //IP등록
    socket = io('https://9cb9-59-6-82-123.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to server');
      //roomId로 룸 가입
      socket.emit('joinRoom',widget.roomId);
    });

    socket.on('socketId', (socketId) {
      print('socketId : $socketId');
      setState(() {
        _socketId = socketId;
      });
    });


    socket.on('receiveMessage', (message) {
      ChatDTO chatDTO = ChatDTO.fromJson(message);
      setState(() {
        chats.add(chatDTO);
        _scrollToBottom();
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      //emit할때 배열로 인자 2개(message,roomId) 안 넣으면 receiveMessage가 안옴 -> 룸안에 있는 사람에게 전역으로 revicemessage를 주기 때문
      ChatDTO sendChatDTO = ChatDTO(id: _socketId, message: _messageController.text );
      socket.emit('sendMessage', [sendChatDTO, widget.roomId]);
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 14,
                ),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final isMine = chats[index].id == _socketId;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: isMine
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7, // 말풍선의 최대 너비 설정
                        ),
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
                          chats[index].message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          softWrap: true,
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
                      _sendMessage(),
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

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
    };
  }

  // JSON을 객체로 변환하는 factory constructor
  factory ChatDTO.fromJson(Map<String, dynamic> json) {
    return ChatDTO(
      id: json['id'],
      message: json['message'],
    );
  }
}

mixin class ScrollControlMixin {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}
