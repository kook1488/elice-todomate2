import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todomate/chat/models/chat_model.dart';
import 'package:todomate/chat/models/user_info.dart';


class ChatDetailScreen extends StatefulWidget {
  final UserInfo userInfo;

  const ChatDetailScreen({super.key, required this.userInfo});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _name = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> topics = ['주제1', '주제2', '주제3'];

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  String _setTextFieldDate(DateTime date) {
    final stringDate = date.toString().split(' ').first;
    return stringDate;
  }

  String _setTextFieldTime(TimeOfDay time) {
    final stringTime = '${time.hour}:${time.minute}';
    return stringTime;
  }

  @override
  void initState() {
    super.initState();
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

  Future selectDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return child != null ? Theme(data: ThemeData.dark(), child: child) : const SizedBox();
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future selectTimePicker() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveChatRoom() {
    final newChat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch, // 유니크한 ID 생성
      title: _name,
      date: DateTime.now(),
      image: '', // 채팅방 이미지
      unread: 0, name: '', lastMessage: '',
    );
    Navigator.of(context).pop(newChat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _onClosePressed,
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                ),
                IconButton(
                  onPressed: _saveChatRoom,
                  icon: const FaIcon(FontAwesomeIcons.check),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Text('방 이름', style: TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text('주제 선택', style: TextStyle(fontSize: 17)),
              ],
            ),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                child: const Text('선택하기'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('주제를 선택하세요.', style: TextStyle(fontSize: 25)),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    for (String topic in topics)
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black12),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(child: Text(topic)),
                                      ),
                                  ],
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
                Text('날짜 선택', style: TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: selectDatePicker,
                child: Text(_setTextFieldDate(_selectedDate)),
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text('시간 선택', style: TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: selectTimePicker,
                child: Text(_setTextFieldTime(_selectedTime)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
