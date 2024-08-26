import 'package:flutter/material.dart';
import 'package:todomate/screens/my/avatar_change.dart';
import 'package:todomate/screens/my/image_change.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class ProfileChange extends StatelessWidget {
  final String loginId;
  final String nickname; // nickname 변수를 추가

  ProfileChange({required this.loginId, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // 배경색 설정
        appBar: AppBar(
          backgroundColor: Colors.grey, // 앱바 배경색
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼
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
                // 이쪽 버튼 사이에 구현이 안되는거 해결 해야할듯
                child: Container(
                  color: Colors.white,
                  width: 320.0,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Column의 주 축에서 시작
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 차게
                    children: [
                      SizedBox(height: 35.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageChange(
                                      loginId: loginId,
                                      nickname: nickname,
                                    )),
                          );
                        },
                        child: buildMenuItemWithImage(
                            'asset/image/woman.png', "이미지 변경"),
                      ),

                      SizedBox(height: 12.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvatarChange(
                                loginId: loginId,
                                nickname:
                                    nickname, // nickname 파라미터를 직접 전달 // nickname 파라미터 추가
                              ),
                            ),
                          );
                        },
                        child: buildMenuItemWithImage(
                            'asset/image/man.png', "아바타 변경"),
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
  Widget buildMenuItemWithImage(String imagePath, String text) {
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
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 48.0,
                  height: 48.0,
                ),
              ),
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
