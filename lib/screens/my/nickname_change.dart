import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class NicknameChange extends StatelessWidget {
  final String loginId;
  final String nickname;
  final TextEditingController _nicknameController = TextEditingController();

  NicknameChange({required this.loginId, required this.nickname});

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
        resizeToAvoidBottomInset: false, // 이 줄을 추가하여 키보드가 나타날 때 레이아웃 재조정을 방지
        body: SafeArea(
          //
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
                          contentPadding: EdgeInsets.zero,
                          // 패딩을 없애서 아이콘과 텍스트를 최대한 가깝게
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
                          //[1]버튼 눌렀을때
                          String newNickname = _nicknameController.text;
                          if (newNickname.isNotEmpty) {
                            // 1. ProfileProvider의 updateNickname 메서드를 호출하여 닉네임을 업데이트
                            await context
                                .read<ProfileProvider>()
                                .updateNickname(loginId, newNickname);

                            // 2. 변경된 닉네임을 다시 로드하여 화면을 갱신
                            await context
                                .read<ProfileProvider>()
                                .loadNickname(loginId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 5,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 70.0, vertical: 10.0),
                        ),
                        child: Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),

                      //kook[1] 알림작업 과정: 1.버튼클릭 2.DB에 메서드 생성 3.프로바이더 클래스 구현 4.알림클래스 구현 5.UI에서 메서드 호출
                      //  cf 구현순서 : 1버튼클릭,2프로바이더 메서드 호출,3.DB에 변경정보 저장,
                      //               4. 마이프로필 열때 알림 전송 5.로컬 알림 전송
                      //kook[5]버튼 클릭 시 saveNicknameChangeForFriends 메서드가 호출
                      ElevatedButton(
                        onPressed: () async {
                          String newNickname = _nicknameController.text;

                          if (newNickname.isNotEmpty) {
                            // 닉네임 변경 후 친구들에게 알림 저장 //
                            await context
                                .read<ProfileProvider>()
                                .saveNicknameChangeForFriends(
                                    loginId, newNickname); //
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 5,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 10.0),
                        ),
                        child: Text(
                          'Change Call',
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 80.0),
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
                          elevation: 8,
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
