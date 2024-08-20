import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 추가
import 'package:todomate/screens/my/profile_provider.dart'; // ProfileProvider 추가

class ProfileWidget extends StatelessWidget {
  final String? nickname;

  ProfileWidget({this.nickname});

  @override
  Widget build(BuildContext context) {
    // ProfileProvider의 avatarPath를 가져옴
    final avatarPath = context.watch<ProfileProvider>().avatarPath;

    return Container(
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
                  backgroundImage: avatarPath != null //null인지판단
                      ? AssetImage(
                          avatarPath) //null이 아니면 해당경로의 이미지를 불러와 배경이미지로 사용
                      : null, // 현재 선택된 프로필 이미지 경로 사용
                ),
              ),
              SizedBox(width: 60.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname ?? 'Loading...',
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
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        TextSpan(
                          text: '7개',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '완료한 일 ',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        TextSpan(
                          text: '5개',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '내가 쓴 일기 1개',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
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
                  Icon(Icons.favorite, size: 40.0, color: Colors.orange),
                  Text('4',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  Text('함께하는 친구',
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.chat_rounded, size: 40.0, color: Colors.orange),
                  Text('5',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  Text('참여중인 채팅방',
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.star, size: 40.0, color: Colors.orange),
                  Text('2',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  Text('예약한 채팅방',
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
