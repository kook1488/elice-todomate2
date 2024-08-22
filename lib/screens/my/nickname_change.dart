import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
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
              // 하단 버튼 섹션
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
                      SizedBox(height: 30.0),
                      // 첫 번째 버튼 추가된 부분
                      ElevatedButton(
                        onPressed: () async {
                          String newNickname = _nicknameController.text;
                          if (newNickname.isNotEmpty) {
                            // Provider를 통해 닉네임 업데이트
                            await context
                                .read<ProfileProvider>()
                                .updateNickname(loginId, newNickname);

                            // 화면 갱신을 위해 닉네임을 다시 로드
                            await context
                                .read<ProfileProvider>()
                                .loadNickname(loginId);
                            //확인용 로그 추가
                            // print('닉네임 변경 요청: $newNickname'); 됨
                          }
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
                              horizontal: 70.0, vertical: 10.0),
                        ),
                        child: Text(
                          'Change', // 첫 번째 버튼의 텍스트
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: () async {
                          // String newNickname = _nicknameController.text;
                          //
                          // if (newNickname.isNotEmpty) {
                          //   await context
                          //       .read<ProfileProvider>()
                          //       .updateNickname(
                          //           loginId, newNickname); //%% 닉네임 변경 후 알림 전송
                          // }
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
                              horizontal: 35.0, vertical: 10.0),
                        ),
                        child: Text(
                          'Change Call', // 첫 번째 버튼의 텍스트
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      SizedBox(height: 80.0), // 두 버튼 사이의 간격
                      ElevatedButton(
                        onPressed: () {
                          // pop
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8, // 그림자 효과
                          shadowColor: Colors.grey.withOpacity(0.5),
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
