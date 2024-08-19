import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todomate/screens/chat_room/test_models.dart';
import 'package:todomate/screens/chat_room/chat_room.dart';

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({
    super.key,
  });

  @override
  State<CreateChatRoomScreen> createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final TextEditingController _nameController = TextEditingController();

  final DatabaseHelper db = DatabaseHelper();
  late Future<List<ChatRoomModel>> chatRooms;
  late Future<List<TopicModel>> topics;
  late Future<String> topicName;
  late int topicId;

  String _name = '';
  String topicNameString = '선택하기';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  String _setDateToString(DateTime date) {
    final stringDate = date.toString().split(' ').first;
    return stringDate;
  }

  String _setStartTimeToString(TimeOfDay time) {
    final stringTime = '${time.hour}:${time.minute}';
    return stringTime;
  }

  String _setEndTimeToString(TimeOfDay time) {
    final stringTime = '${time.hour + 1}:${time.minute}';
    return stringTime;
  }

  @override
  void initState() {
    super.initState();

    // 채팅방 DB 초기화
    db.initDatabase();

    chatRooms = db.getChatRoom();
    topics = db.getTopic();

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addChatRoom() async {
    if (_nameController.text.isNotEmpty) {
      await db.insertChatRoomModel(ChatRoomModel(
        name: _name,
        topicId: topicId,
        userId: 1,
        startDate:
            '${_setDateToString(_selectedDate)} ${_setStartTimeToString(_selectedTime)}',
        endDate:
            '${_setDateToString(_selectedDate)} ${_setEndTimeToString(_selectedTime)}',
      ));
      _nameController.clear();

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChatRoomScreen(),
          ),
        );
      }
    }
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
      setState(() => _selectedDate = picked);
    }
  }

  // 시간 선택 함수
  Future selectTimePicker() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<String> _topicName(int id) async {
    topicName = db.getTopicDetailName(topicId: id);
    topicNameString = await topicName;
    return topicNameString.toString();
  }

  // 토픽 선택
  void _onTopicDetailTap(TopicModel detail) {
    topicId = detail.id!.toInt();
  }

  void _onTopicSelectTap() {
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar의 높이 설정
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      // body
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 뒤로가기 버튼
                IconButton(
                  onPressed: _onClosePressed,
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                ),
                // 저장 버튼
                IconButton(
                  onPressed: _addChatRoom,
                  icon: const FaIcon(FontAwesomeIcons.check),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
              onChanged: (value) {
                _name = value;
              },
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
                child: Text(_setDateToString(_selectedDate)),
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
                child: Text(_setStartTimeToString(_selectedTime)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
