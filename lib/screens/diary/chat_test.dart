import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

//1 Node JS- 서버구축할 수 있게 해주는거  원교님 쓴느 와이파이로 옴
//노드 js 는 구축할때만 쓴다.
//VS코드로 노드 js 로 서버 구축 mpn =nod js서버 까는 방법

//2 소켓io 라이브러리 = 실시간으로 통신할 수 있게 만들어주는것
//클라이언트 - 앱자체.
//원교님 동네로 간것

//3 nglock 로컬에 네트워크를 열었을때
//다른사람이 내 로컬에 들어 올 수 있게 하는것.

//4 json은 객체로 보내야 하니깐. 스트링만 보내는게 아니라 :모든 언어에서 사용할 수 있게 한 데이터덩어리
//자바스크립트랑 다트랑 : 스트링- 객체로 하고  받는데서 객체를 스트링 형태로 하고 받
//제이슨이 객체를 스트링 데이터로 만듬
//안드로이드 스튜디오에도 깐다.

//1 서버구축nod js
//2 안드노드 소켓io 연동시킨 후 3채팅 확인할 때 json후
//4 마지막으로 nglock 으로

class ChatScreenTest extends StatefulWidget {
  final String roomId;
  const ChatScreenTest({super.key, required this.roomId});

  @override
  State<ChatScreenTest> createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest>
    with ScrollControlMixin {
  late Socket socket; // 별칭 없이 직접 사용
  late TextEditingController _messageController;
  //채팅방 메시지 객체 리스트
  List<ChatDTO> chats = [];
  String _socketId = '';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    //소켓 접속
    _connectSocket();
  }

  void _connectSocket() {
    //IP등록
    socket = io('https://be35-59-6-82-123.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to server');
      //roomId로 룸 가입
      socket.emit('joinRoom', widget.roomId);
    });

    //연결 성공시 서버에서 socketId 보내주면 초기화
    socket.on('socketId', (socketId) {
      print('socketId : $socketId');
      setState(() {
        _socketId = socketId;
      });
    });

    socket.on('receiveMessage', (message) {
      //채팅 객체를 josn형태로 받아서 ChatDTO로 파싱
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
      //emit할때 배열로 인자 2개(message,roomId) 안 넣으면 receiveMessage가 안옴 ->
      // 룸안에 있는 사람에게 전역으로 revicemessage를 주기 때문

      ChatDTO sendChatDTO =
          ChatDTO(id: _socketId, message: _messageController.text);
      //채팅 객체를 json으로 파싱해서 보냄
      socket.emit('sendMessage', [sendChatDTO.toJson(), widget.roomId]);
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
                  //현재 내 socketId와 같으면 오른쪽 메시지 다르면 왼쪽 메시지
                  final isMine = chats[index].id == _socketId;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: isMine
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        //가로로 채팅 최대로 넘어갈 시 오류나서 최대값 정해줌
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.7, // 말풍선의 최대 너비 설정
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
                          //textview 자동줄바꿈
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
                    onPressed: () => {
                      _sendMessage(),
                      //전송버튼 누르면 보내던것 초기화
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

class ChatDTO {
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
