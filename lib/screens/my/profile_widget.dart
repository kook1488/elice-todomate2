import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/todo/todo_provider.dart';

class ProfileWidget extends StatelessWidget {
  final String? nickname;

  ProfileWidget({this.nickname});

  @override
  Widget build(BuildContext context) {
    // ProfileProvider의 상태를 가져옴
    final avatarPath = context.watch<ProfileProvider>().avatarPath;
    final int todoCount =
        context.watch<TodoProvider>().incompleteTodoCount; // 완료되지 않은 할 일 개수 사용
    final int completedTodoCount = context
        .watch<TodoProvider>()
        .completedTodoCount; // TodoProvider에서 완료된 할 일 개수 가져옴
    final int diaryCount = context.watch<ProfileProvider>().diaryCount;
    final int friendCount = context.watch<ProfileProvider>().friendCount;
    final int activeChatCount =
        context.watch<ProfileProvider>().activeChatCount;
    final int reservedChatCount =
        context.watch<ProfileProvider>().reservedChatCount;

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
                  backgroundImage: avatarPath != null
                      ? AssetImage(avatarPath)
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
                          text: '$todoCount개', // 해야할 일 개수 변수 사용
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
                          text: '$completedTodoCount개', // 완료한 일 개수 변수 사용
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
                          text: '내가 쓴 일기 $diaryCount개', // 일기 개수 변수 사용
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
                  Text('$friendCount',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  Text('함께하는 친구',
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.chat_rounded, size: 40.0, color: Colors.orange),
                  Text('$activeChatCount',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  Text('참여중인 채팅방',
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.star, size: 40.0, color: Colors.orange),
                  Text('$reservedChatCount',
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
