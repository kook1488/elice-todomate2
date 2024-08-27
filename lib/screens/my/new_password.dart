import 'package:flutter/material.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class NewPassword extends StatelessWidget {
  final String loginId;
  final String nickname; // 닉네임을 받아올 변수

  NewPassword({required this.loginId, required this.nickname});

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
            child: Column(
              children: [
                // 상단 프로필 섹션
                ProfileWidget(nickname: nickname),

                // 하단 섹션
                Container(
                  color: Colors.white,
                  width: 320.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 130.0),
                      Center(
                        child: Text(
                          "새로운 암호를 입력하세요",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 120.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            // New Password Field
                            Container(
                              width: double.infinity,
                              child: TextField(
                                obscureText: true, // 비밀번호 형식으로 보이게 설정
                                decoration: InputDecoration(
                                  hintText: "New Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                  ),
                                  suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            // Confirm Password Field
                            Container(
                              width: double.infinity,
                              child: TextField(
                                obscureText: true, // 비밀번호 형식으로 보이게 설정
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                  ),
                                  suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 16.0,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
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
                                  builder: (context) =>
                                      ProfileScreen(loginId: loginId)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          child: Text(
                            '확인',
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
}
