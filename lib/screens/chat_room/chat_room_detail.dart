import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';
import 'package:todomate/screens/chat_room/test_models.dart';
import 'package:todomate/screens/chat_room/chat_room.dart';
import 'package:todomate/screens/todo/todo_provider.dart';

class ChatRoomDetailScreen extends StatefulWidget {
  final ChatRoomModel chatRoomDetail;

  const ChatRoomDetailScreen({
    super.key,
    required this.chatRoomDetail,
  });

  @override
  State<ChatRoomDetailScreen> createState() => ChatRoomDetailScreenState();
}

class ChatRoomDetailScreenState extends State<ChatRoomDetailScreen> {
  late TextEditingController _nameController = TextEditingController();
  late Future<List<ChatRoomModel>> chatRooms;
  late Future<List<TopicModel>> topics;
  String _name = '';
  late String _selectedDate;
  late String _selectedTime;
  TimeOfDay a = TimeOfDay.now();
  late int topicId;
  late Future<String> topicName;
  String topicNameString = '';
  final DatabaseHelper db = DatabaseHelper();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  String _setDateToString(DateTime date) {
    final stringDate = date.toString().split(' ').first;
    return stringDate;
  }

  TimeOfDay _setStringToTime(String time) {
    DateTime dateTime = DateFormat("HH:mm").parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  String _setStartTimeToString(TimeOfDay time) {
    final stringTime = '${time.hour}:${time.minute}';
    return stringTime;
  }

  String _setEndTimeToString(String time) {
    DateTime endTime = DateFormat("HH:mm").parse(time);
    final stringTime = '${endTime.hour + 1}:${endTime.minute}';
    return stringTime;
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.chatRoomDetail.name);
    _selectedDate = widget.chatRoomDetail.startDate.split(' ').first;
    _selectedTime = widget.chatRoomDetail.startDate.split(' ')[1];
    topicId = widget.chatRoomDetail.topicId.toInt();

    _nameController.addListener(() {
      setState(() {
        if (_nameController.text.isEmpty) {
          _name = _nameController.text;
        }
      });
    });

    // db.initDatabase();
    chatRooms = db.getChatRoom();
    topics = db.getTopic();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateChatRoom(ChatRoomModel chatRoom) async {
    if (_nameController.text.isEmpty) {
      _name = widget.chatRoomDetail.name;
    } else {
      _name = _nameController.text;
    }

    final detail = ChatRoomModel(
      id: chatRoom.id,
      name: _name,
      topicId: topicId,
      userId: 1,
      startDate: '$_selectedDate $_selectedTime',
      endDate: '$_selectedDate ${_setEndTimeToString(_selectedTime)}',
    );

    // Provider를 가져와서 상태 변화를 감지하지 않도록 설정
    final chatRoomProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);

    // 새로운 Todo를 TodoProvider에 추가합니다.
    chatRoomProvider.updateChatRoomDetail(detail);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  // 토픽 선택
  void _onTopicDetailTap(TopicModel detail) {
    topicId = detail.id!.toInt();
  }

  Future<String> _topicName(int id) async {
    topicName = db.getTopicDetailName(topicId: id);
    topicNameString = await topicName;
    return topicNameString.toString();
  }

  void _onTopicSelectTap() {
    Navigator.of(context).pop(true);
  }

  // 날짜 선택 함수
  Future selectDatePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return child != null
              ? Theme(data: ThemeData.dark(), child: child)
              : const SizedBox();
        });
    if (picked != null) {
      setState(() => _selectedDate = _setDateToString(picked));
    }
  }

  // 시간 선택 함수
  Future selectTimePicker() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _setStringToTime(_selectedTime),
        initialEntryMode: TimePickerEntryMode.input);
    if (picked != null) {
      setState(() => _selectedTime = _setStartTimeToString(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: const Text('채팅방 수정'),
        actions: [
          IconButton(
            onPressed: () => _updateChatRoom(widget.chatRoomDetail),
            icon: const FaIcon(FontAwesomeIcons.check),
          ),
        ],
      ),
      // body
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  '방 이름',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 텍스트 입력 필드
            TextField(
              controller: _nameController,
              onChanged: (value) {
                _name = value;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text(
                  '주제 선택',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                child: FutureBuilder<String>(
                  future: _topicName(topicId),
                  builder: (context, topicSnapshot) {
                    if (topicSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text('주제: 불러오는 중...');
                    } else if (topicSnapshot.hasError) {
                      return Text('주제: 오류 발생 - ${topicSnapshot.error}');
                    } else if (topicSnapshot.hasData) {
                      return Text('${topicSnapshot.data}');
                    } else {
                      return const Text('주제: 데이터 없음');
                    }
                  },
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          height: 230,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      '주제를 선택하세요.',
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                FutureBuilder(
                                  future: topics,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<TopicModel> topicList =
                                      snapshot.data as List<TopicModel>;
                                      return Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: topicList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 70,
                                              height: 70,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: GestureDetector(
                                                onTap: () => _onTopicDetailTap(
                                                    topicList[index]),
                                                child: Center(
                                                  child: Text(
                                                    topicList[index].name,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _onTopicSelectTap,
                                  child: const Text('저장'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text(
                  '날짜 선택',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: selectDatePicker,
                child: Text(_selectedDate),
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text(
                  '시간 선택',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: selectTimePicker,
                child: Text(_selectedTime),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomAppBar(),
    );
  }
}
