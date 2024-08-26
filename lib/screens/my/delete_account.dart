import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/account/loginscreen.dart';
import 'package:todomate/screens/my/profile_widget.dart';

class DeleteAccount extends StatelessWidget {
  final String nickname;
  //탈퇴작업 DB 178번째 줄
  final String loginId; // 사용자의 loginId를 받아서 처리
  DeleteAccount({required this.loginId, required this.nickname});
  // 생성자에서 loginId 를 전달받음
  // required 는 어떤변수에 어떤 값을 넣을지 설정해줘야한다
//{}안에 매게변수는 원래는 선택적인데,
// requiered 로 삭제시 코드 안에서 loginId꼭 넣어주도록 한다.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                child: Container(
                  color: Colors.white,
                  width: 320.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 80.0),
                      // 탈퇴 질문과 버튼들
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '회원님,\n탈퇴하시겠습니까?',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 250.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            //탈퇴작업
                            onPressed: () async {
                              // final : 불변변수  ,DatabaseHelper 인스턴스 가져오기
                              final dbHelper = DatabaseHelper();
                              // loginId를 기반으로 사용자 삭제
                              await dbHelper.deleteUserByLoginId(loginId);
                              // 로그인 화면으로 이동 및 이전 페이지 스택 제거
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 55.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              '네',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 40.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              '아니오',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // 메뉴 아이템 빌드 함수 -겹침
  // Widget buildMenuItem(IconData icon, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Container(
  //       padding: EdgeInsets.all(16.0),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12.0),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.3),
  //             spreadRadius: 2,
  //             blurRadius: 5,
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 24.0,
  //             backgroundColor: Colors.grey[300],
  //             child: Icon(icon, color: Colors.black, size: 30.0),
  //           ),
  //           SizedBox(width: 16.0),
  //           Text(
  //             text,
  //             style: TextStyle(
  //               fontSize: 18.0,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
