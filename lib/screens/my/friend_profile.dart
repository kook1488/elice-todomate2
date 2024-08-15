import 'package:flutter/material.dart';

class friend_profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // 배경색 설정
        appBar: AppBar(
          backgroundColor: Color(0xFFFF642D), // 앱바 배경색을 이미지처럼 오렌지색으로 변경
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // 뒤로가기 버튼
            onPressed: () {},
          ),
          title:
              Text('스티븐', style: TextStyle(color: Colors.white)), // 사용자 이름 추가
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 상단 프로필 섹션
              Container(
                color: Color(0xFFFF642D), // 상단 배경색을 오렌지색으로 변경
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage('asset/image/man.png'), // 프로필 이미지 경로
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '스티븐',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // 통계 섹션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.school, size: 40.0, color: Colors.white),
                            SizedBox(height: 4.0),
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
                                size: 40.0, color: Colors.white),
                            SizedBox(height: 4.0),
                            Text('5',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('스티븐이 해야할일',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.star, size: 40.0, color: Colors.white),
                            SizedBox(height: 4.0),
                            Text('2',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('내가 해야할일',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 친구 리스트 섹션
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.orange),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Colors.orange),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book, color: Colors.orange),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFriendListItem(int index) {
    // index를 매개변수로 받음
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      AssetImage('asset/image/man.png'), // 친구의 프로필 이미지 경로
                ),
                title: Text(
                  'Flutter 워크프레임워크 연구', // 예시 텍스트, 실제 데이터로 변경 필요
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('스티븐'),
                    SizedBox(height: 4.0),
                    Text(
                      '24.08.17일까지', // 날짜는 실제 데이터로 변경 필요
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: index % 2 == 0, // 예시로 짝수 인덱스에 체크
                      onChanged: (bool? value) {},
                    ),
                    Checkbox(
                      value: index % 2 == 1, // 예시로 홀수 인덱스에 체크
                      onChanged: (bool? value) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
