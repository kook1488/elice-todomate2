import 'package:flutter/material.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class ImageChange extends StatelessWidget {
  final String loginId;
  final String nickname;

  ImageChange({required this.loginId, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          child: Column(
            children: [
              // 상단 프로필 섹션
              ProfileWidget(nickname: nickname),
              // 하단 버튼 섹션
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 100.0),

                      // 첫 번째 Change 버튼
                      ElevatedButton(
                        onPressed: () {
                          // Change 버튼 동작
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 첫 번째 버튼 색상 변경 가능
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
                      SizedBox(height: 100.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
