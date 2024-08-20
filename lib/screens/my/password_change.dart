import 'package:flutter/material.dart';
import 'package:todomate/screens/my/new_password.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class PasswordChange extends StatelessWidget {
  final String loginId;
  final String nickname;

  PasswordChange({required this.loginId, required this.nickname});

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
          child: SingleChildScrollView(
            // SingleChildScrollView로 감쌈
            child: Column(
              children: [
                // 상단 프로필 섹션
                ProfileWidget(nickname: nickname),

                // 하단 섹션
                Container(
                  color: Colors.white,
                  width: 320.0,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Column의 주 축에서 시작
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 차게
                    children: [
                      SizedBox(height: 35.0),
                      buildMenuItem(Icons.verified, "인증번호 전송"),
                      SizedBox(height: 130.0),
                      Center(
                        child: Text(
                          "email로 전송된 번호 4자리를 입력해 주세요..",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0), // 전체 화면에서의 좌우 여백
                        child: Container(
                          width: 250.0, // 텍스트 필드의 너비를 조절
                          child: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              hintText: "****",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                              counterText: "", // 카운터 텍스트 숨김
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, // 텍스트 필드의 높이를 조절
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 24.0,
                              letterSpacing: 10.0, // 숫자 사이 간격
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewPassword(
                                        loginId: loginId,
                                        nickname: nickname,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // 버튼 배경색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 40.0),
                          ),
                          child: Text(
                            '암호 재설정하기',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
