import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todomate/models/diary_model.dart';
import 'package:todomate/screens/diary/diary_modify_screen.dart';

import '../../models/signup_model.dart';
import '../../util/alert_dialog.dart';
import '../../util/string_utils.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryDTO diaryDTO;

  const DiaryDetailScreen({super.key, required this.diaryDTO});

  @override
  State<StatefulWidget> createState() => DiaryDetailScreenState();
}

class DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late DateTime _selectedDate;

  String? imageFilePath;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    imageFilePath = widget.diaryDTO.imageUrl ?? '';
    if (widget.diaryDTO.imageUrl != null) {
      _selectedImage = File(widget.diaryDTO.imageUrl ?? '');
    }
    _selectedDate = widget.diaryDTO.createAt;
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
          '일기',
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.diaryDTO.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black, // 텍스트 색상
                      ),
                      textAlign: TextAlign.left, // 텍스트를 중앙에 배치합니다.
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    // 버튼에서 padding이 빠졌으니, 여기에 추가합니다.
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // 버튼의 배경색을 유지하기 위해 색상을 지정합니다.
                      borderRadius: BorderRadius.circular(8),
                      // 버튼의 모서리 둥글기를 유지합니다.
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2), // 그림자 위치를 설정합니다.
                        ),
                      ],
                    ),
                    child: Text(
                      dateToString(_selectedDate),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black, // 텍스트 색상
                      ),
                      textAlign: TextAlign.left, // 텍스트를 중앙에 배치합니다.
                    ),
                  ),
                  SizedBox(height: 10),
                  _selectedImage != null
                      ? Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16.0), // 버튼의 padding을 유지합니다.
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경색을 설정합니다.
                            borderRadius:
                                BorderRadius.circular(8), // 모서리를 둥글게 만듭니다.
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2), // 그림자 효과를 줍니다.
                              ),
                            ],
                          ),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox.shrink(),
                  _selectedImage != null
                      ? SizedBox(height: 10)
                      : SizedBox.shrink(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0), // 패딩 추가
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2), // 그림자 위치를 설정합니다.
                        ),
                      ],
                    ),
                    child: Text(
                      widget.diaryDTO.description,
                      style: TextStyle(fontSize: 16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DiaryModifyScreen(diaryDTO: widget.diaryDTO)),
                  ).then((result) {
                    if (result != null) {
                      // 데이터를 받아서 처리
                      Navigator.pop(context, true); // 데이터베이스에서 다시 데이터를 불러오는 메서드
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _deleteDiary();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteDiary() async {
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
}
