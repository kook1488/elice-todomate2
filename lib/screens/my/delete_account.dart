import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart';

class delete_account extends StatelessWidget {
  //178번째 줄
  final String loginId; // 사용자의 loginId를 받아서 처리

  // 생성자에서 loginId를 전달받음
  DeleteAccount({required this.loginId});

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
                            onPressed: () async {
                              // DatabaseHelper 인스턴스 가져오기
                              final dbHelper = DatabaseHelper();

                              // loginId를 기반으로 사용자 삭제
                              int result =
                                  await dbHelper.deleteUserByLoginId(loginId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey, // 회색 버튼
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
                              backgroundColor: Colors.orange, // 오렌지색 버튼
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
