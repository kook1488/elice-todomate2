import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/diary_model.dart';


import '../../models/signup_model.dart';
import '../../util/alert_dialog.dart';
import '../../util/string_utils.dart';

class DiaryModifyScreen extends StatefulWidget {
  final DiaryDTO diaryDTO;

  const DiaryModifyScreen({super.key, required this.diaryDTO});

  @override
  State<StatefulWidget> createState() => DiaryModifyScreenState();
}

class DiaryModifyScreenState extends State<DiaryModifyScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;

  String? imageFilePath;
  File? _selectedImage;

  late ImagePicker _picker;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.diaryDTO.title);
    if (widget.diaryDTO.imageUrl != null) {
      _selectedImage = File(widget.diaryDTO.imageUrl!);
    }
    _contentController =
        TextEditingController(text: widget.diaryDTO.description);
    _selectedDate = widget.diaryDTO.createAt;
    _picker = ImagePicker();
    super.initState();
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
          '일기 수정',
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '수정',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _updateDiary() async {
    try {
      bool isSuccessDeleteDiary =
      await DatabaseHelper().deleteDiary(widget.diaryDTO.id ?? 0);
      if (isSuccessDeleteDiary) {
        showAlertDialog(context, '알림', '삭제 되었습니다.', shouldPop: true);
      } else {
        showAlertDialog(context, "알림", "삭제 실패했습니다.");
      }
    } catch (e) {
      showAlertDialog(context, '오류', '삭제 중 오류가 발생했습니다.');
    }
  }

  //달력에서 날짜 선택
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

  //이미지 가져오기
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFilePath = pickedFile.path;
      setState(() {
        _selectedImage = File(imageFilePath ?? '');
      });
    }
  }

}
