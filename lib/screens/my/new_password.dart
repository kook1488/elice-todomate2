import 'package:flutter/material.dart';

class new_password extends StatelessWidget {
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
                Container(
                  color: Colors.grey,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.school,
                                  size: 40.0, color: Colors.orange),
                              Text(
                                '4',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              Text(
                                '함께 완료한일',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ),
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
                              Icon(Icons.star,
                                  size: 40.0, color: Colors.orange),
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
                          onPressed: () {},
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
