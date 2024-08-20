import 'package:flutter/material.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class AvatarChange extends StatelessWidget {
  final String loginId;
  final String nickname; // 닉네임을 전달받음

  AvatarChange({required this.loginId, required this.nickname});

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
              ProfileWidget(nickname: nickname), // UpperProfile 위젯 사용
              // 하단 그리드뷰 및 버튼 섹션
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      Expanded(
                        child: GridView.builder(
                          itemCount: 6, // 아이템 개수
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 한 줄에 보여줄 아이템 개수
                            crossAxisSpacing: 8.0, // 아이템 사이의 가로 간격
                            mainAxisSpacing: 8.0, // 아이템 사이의 세로 간격
                            childAspectRatio: 1.0, // 아이템의 가로:세로 비율
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                'asset/image/avata_1.png', // 이미지 경로
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(loginId: loginId)),
                          ); // loginId 전달
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
                          'change',
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
