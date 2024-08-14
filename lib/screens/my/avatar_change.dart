import 'package:flutter/material.dart';

class avatar_change extends StatelessWidget {
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
                                'asset/image/avatar.png'), // 프로필 이미지 경로
                          ),
                        ),
                        SizedBox(width: 60.0),
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
              // 하단 그리드뷰 및 버튼 섹션
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      Expanded(
                        child: GridView.builder(
                          itemCount: 6, // 아이템 개수
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 한 줄에 보여줄 아이템 개수
                            crossAxisSpacing: 8.0, // 아이템 사이의 가로 간격
                            mainAxisSpacing: 8.0, // 아이템 사이의 세로 간격
                            childAspectRatio: 1.0, // 아이템의 가로:세로 비율
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                'asset/image/man.png', // 이미지 경로
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // 버튼 배경색
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
                      SizedBox(height: 60.0), // 버튼과 화면 하단 사이의 간격 추가
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
