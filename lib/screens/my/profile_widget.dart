import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';
import 'package:todomate/screens/diary/diary_provider.dart';
import 'package:todomate/screens/my/profile_provider.dart';
import 'package:todomate/screens/todo/todo_provider.dart';

class ProfileWidget extends StatelessWidget {
  final String? nickname;

  ProfileWidget({this.nickname});

  @override
  Widget build(BuildContext context) {
    // [6]kook 친구가 마이프로필 열때 닉네임 변경 알림 전송

    final profileProvider =
        context.read<ProfileProvider>(); //^^ 프로바이더 인스턴스 가져오기
    final List<String> acceptedFriends = [
      // 친구 목록을 받아와야 함
      "friend1",
      "friend2",
      // 추가 친구 ID...
    ];
    // 마이프로필을 열 때 친구가 받은 닉네임 변경 알림 확인

    profileProvider.notifyNicknameChange(acceptedFriends);

    // ProfileProvider의 activeChatCount 업데이트
    // activeChatCount를 ChatRoomProvider와 연동하여 업데이트
    context
        .read<ProfileProvider>()
        .updateActiveChatCount(context.read<ChatRoomProvider>());
    //TODO:
    //지금은 watch에서 프로바이더를 가져옴
    // ProfileProvider의 상태를 가져옴
    //디비로 초기값을 가져오는게 좋을 듯.. //watch가 디비를 관찰하는거 아닐까?
    final avatarPath = context.watch<ProfileProvider>().avatarPath;
    //[4] 프로바이더에서 DB 변경과 동시에 notifyListeners 호 호출 받아서
    // profileProvider에 연결된 모든 UI 가 새 닉네임 반영
    //호출 받아서 닉네임 업데이트
    final String? currentNickname =
        context.watch<ProfileProvider>().nickname; //변경된 닉네임을 반영

    final int todoCount =
        context.watch<TodoProvider>().incompleteTodoCount; // 완료되지 않은 할 일 개수 사용
    final int completedTodoCount = context
        .watch<TodoProvider>()
        .completedTodoCount; // TodoProvider에서 완료된 할 일 개수 가져옴
    final int diaryCount = context
        .watch<DiaryProvider>()
        .getDiaryCount(); // DiaryProvider에서 일기 개수를 가져옴
    final int friendCount = context.watch<ProfileProvider>().friendCount;
    final int activeChatCount =
        context.watch<ProfileProvider>().activeChatCount; //activeChatCount를 사용
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
                      ? avatarPath.contains('asset')
                          ? AssetImage(avatarPath)
                              as ImageProvider // 그리드에서 선택한 경우
                          : FileImage(File(avatarPath)) // 갤러리에서 선택한 경우
                      : null, // 현재 선택된 프로필 이미지 경로 사용
                ),
              ),
              SizedBox(width: 60.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentNickname ?? '$nickname',
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
                    /////
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
                  Text('생성된 채팅방',
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
