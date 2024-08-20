import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/my/profile_screen.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class NicknameChange extends StatelessWidget {
  final String loginId;
  final String nickname;
  final TextEditingController _nicknameController = TextEditingController();
  NicknameChange({required this.loginId, required this.nickname});
//디비를 한번 더 불러서 화면을 더 갱신시켜야 한다.

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
        resizeToAvoidBottomInset: false, // 이 줄을 추가하여 키보드가 나타날 때 레이아웃 재조정을 방지
        body: SafeArea(
          child: Column(
            children: [
              // 상단 프로필 섹션
              ProfileWidget(nickname: nickname),
              // 하단 그리드뷰 및 버튼 섹션
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40.0),
                      // 텍스트 필드 추가된 부분
                      TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          hintText: 'New NickName',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 35.0,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.zero, // 패딩을 없애서 아이콘과 텍스트를 최대한 가깝게
                          prefixIcon: Icon(
                            Icons.published_with_changes,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 250.0),
                      ElevatedButton(
                        onPressed: () {
                          //* 닉네임 업데이트 로직
                          context.read<ProfileProvider>().updateNickname(
                              loginId, _nicknameController.text);
                          //* 화면 갱신
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(loginId: loginId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
                      SizedBox(height: 60.0),
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
