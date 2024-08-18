import 'package:flutter/material.dart';

import 'delete_account.dart';
import 'nickname_change.dart';
import 'password_change.dart';
import 'profile_change.dart';

class profile_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // 배경색 설정
        appBar: AppBar(
          backgroundColor: Colors.grey, // 앱바 배경색
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼
            onPressed: () {},
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 상단 프로필 섹션
              Container(
                color: Colors.grey,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // 프로필 이미지
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage(
                                'asset/image/avata_1.png'), // 프로필 이미지 경로
                          ),
                        ),
                        SizedBox(width: 60.0), // 프로필 이미지와 텍스트 사이 간격
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'bluetux',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '해야할일 ',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: '7개',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '함께 하는 친구 ',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: '5명',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '함께 하지 않는 친구 1명',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // 추가된 통계 섹션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.school,
                                size: 40.0, color: Colors.orange),
                            Text('4',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('함께 완료한일',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.favorite,
                                size: 40.0, color: Colors.orange),
                            Text('5',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('함께하는 친구',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.star, size: 40.0, color: Colors.orange),
                            Text('2',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('함께하지 않는 친구',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 하단 버튼 섹션
              Expanded(
                // 이쪽 버튼 사이에 구현이 안되는거 해결 해야할듯
                child: Container(
                  color: Colors.white,
                  width: 320.0,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Column의 주 축에서 시작
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 차게
                    children: [
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profile_change()),
                          );
                        },
                        child: buildMenuItem(Icons.person, "프로필 이미지 변경"),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => nickname_change()),
                          );
                        },
                        child: buildMenuItem(Icons.sync, "닉네임 변경"),
                      ), // 간격 추가

                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => password_change()),
                          );
                        },
                        child: buildMenuItem(Icons.lock, "비밀번호 변경"),
                      ), // 간격 추가

                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => delete_account()),
                          );
                        },
                        child: buildMenuItem(Icons.exit_to_app, "회원 탈퇴"),
                      ), // 간격 추가
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

  // 메뉴 아이템 빌드 함수
  Widget buildMenuItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.grey[300],
              child: Icon(icon, color: Colors.black, size: 30.0),
            ),
            SizedBox(width: 16.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
