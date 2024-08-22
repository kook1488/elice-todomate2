import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todomate/models/diary_model.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/util/alert_dialog.dart';
import 'package:todomate/util/sharedpreference.dart';
import 'package:todomate/util/string_utils.dart'; // 수정된 경로

class DiaryAddScreen extends StatefulWidget {
  final DateTime date;
  const DiaryAddScreen({super.key, required this.date});

  @override
  State<StatefulWidget> createState() => _DiaryAddScreenState();
}

class _DiaryAddScreenState extends State<DiaryAddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;

  String? imageFilePath;
  File? _selectedImage;

  late ImagePicker _picker;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    setUserId();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _selectedDate = widget.date;
    _picker = ImagePicker();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // 초기 날짜를 현재 날짜로 설정
      firstDate: DateTime(2000), // 선택 가능한 최소 날짜
      lastDate: DateTime(2101), // 선택 가능한 최대 날짜
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // 선택된 날짜를 상태에 저장
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFilePath = pickedFile.path;
      setState(() {
        _selectedImage = File(imageFilePath ?? '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '일기 쓰기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '제목',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        elevation: 3.0,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // 텍스트와 아이콘을 양쪽 끝으로 배치
                        children: [
                          Text(
                            dateToString(_selectedDate),
                            style: const TextStyle(
                                color: Colors.black), // 원하는 텍스트 스타일 적용
                          ),
                          const Icon(
                            Icons.calendar_today, // 달력 아이콘
                            color: Colors.black, // 아이콘 색상
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(),
                      style: ElevatedButton.styleFrom(
                        elevation: 3.0,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _selectedImage == null
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // 텍스트와 아이콘을 양쪽 끝으로 배치
                              children: [
                                Text(
                                  '사진을 넣어보세요.',
                                  style: TextStyle(
                                      color: Colors.black), // 원하는 텍스트 스타일 적용
                                ),
                                Icon(
                                  Icons.image, // 달력 아이콘
                                  color: Colors.black, // 아이콘 색상
                                ),
                              ],
                            )
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '오늘 있었던 일을 적어보세요.',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _insertDiary();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '등록',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  //디비 넣기전 변수 검증
  bool checkInsert() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _insertDiary() async {
    try {
      if (checkInsert()) {
        DiaryDTO diary = DiaryDTO(
          userId: _userId,
          title: _titleController.text,
          description: _contentController.text,
          imageUrl: imageFilePath,
          createAt: DateTime(
              _selectedDate.year, _selectedDate.month, _selectedDate.day),
        );

        bool isSuccessInsert = await DatabaseHelper().insertDiary(diary);

        if (isSuccessInsert) {
          // 등록 성공
          // 등록 성공 시 diaryCount 업데이트
          Provider.of<ProfileProvider>(context, listen: false)
              .updateDiaryCount(1);
          showAlertDialog(context, '알림', '등록되었습니다.', shouldPop: true);
        } else {
          // 등록 실패
          showAlertDialog(context, '알림', '등록에 실패했습니다.');
        }
      } else {
        showAlertDialog(context, '알림', '일기 제목과 내용을 입력해주세요.');
      }
    } catch (e) {
      showAlertDialog(context, '오류', '등록 중 오류가 발생했습니다.');
    }
  }

  Future<void> setUserId() async {
    final userId = await TodoSharedPreference().getPreferenceWithKey('userId');

    setState(() {
      _userId = userId;
    });
  }
}
