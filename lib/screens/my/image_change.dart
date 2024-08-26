import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 임포트
import 'package:provider/provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class ImageChange extends StatefulWidget {
  final String loginId;
  final String nickname;

  ImageChange({required this.loginId, required this.nickname});

  @override
  _ImageChangeState createState() => _ImageChangeState();
}

class _ImageChangeState extends State<ImageChange> {
  File? _image; // 선택된 이미지를 저장할 변수

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 선택된 이미지를 _image 변수에 저장
      });

      // 여기에 선택한 이미지를 프로필 사진으로 설정하는 로직을 추가합니다.
      // 예를 들어, 데이터베이스에 저장하거나, 서버로 업로드하는 등의 작업을 수행할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    // 상단 프로필 섹션
                    ProfileWidget(nickname: widget.nickname),
                    // 하단 버튼 섹션
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: _pickImage, // 이미지 선택 메서드 호출
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5, // 그림자 효과
                              shadowColor:
                                  Colors.grey.withOpacity(0.3), // 그림자 색상 및 불투명도
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 10.0),
                            ),
                            child: Text(
                              '사진 올리기',
                              style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),

                          // 버튼들이 밀리지 않도록 추가한 SizedBox
                          SizedBox(height: 200.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_image != null) {
                                context
                                    .read<ProfileProvider>()
                                    .updateAvatarPath(
                                      widget.loginId,
                                      _image!.path,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5, // 그림자 효과
                              shadowColor:
                                  Colors.grey.withOpacity(0.3), // 그림자 색상 및 불투명도
                              padding: EdgeInsets.symmetric(
                                  horizontal: 65.0, vertical: 10.0),
                            ),
                            child: Text(
                              '등록하기',
                              style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // 첫 번째 pop
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange, // 버튼 배경색
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 10.0),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 35.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 60.0), // 버튼과 화면 하단 사이의 간격 추가
                        ],
                      ),
                    ),
                  ],
                ),
                if (_image != null)
                  Positioned(
                    top: 350,
                    left: MediaQuery.of(context).size.width * 0.25, // 가운데 정렬
                    child: Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
