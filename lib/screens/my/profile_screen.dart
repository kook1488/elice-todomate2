import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/my/nickname_change.dart';
import 'package:todomate/screens/my/password_change.dart';
import 'package:todomate/screens/my/profile_change.dart';
import 'package:todomate/screens/my/profile_widget.dart';
import 'package:todomate/util/notification_service.dart';

import 'delete_account.dart';

//유저 객체를 가져와서 유저의 로그인 아이디를 빼와서
// 로그인한 유저의 정보를 삭제해야한다.
// final 변수이므로 반드시 생성자에서 초기화해야 함
// 생성자에서 loginId를 받아 초기화
class ProfileScreen extends StatefulWidget {
  final String loginId;
  ProfileScreen({required this.loginId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState(); // State 클래스 생성
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _nickname; // 닉네임을 저장할 변수 추가
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // DatabaseHelper 인스턴스 추가
  //클래스가 다를때는 위젯으로 가져온다//스테이트 풀위젯일때
  //왜 위젯.login 으로 가져왔는지.,.

  @override
  void initState() {
    super.initState();
    _loadNickname(); // 닉네임을 불러오는 메서드 호출
  }

  @override
  void didChangeDependencies() {
    // 위젯이 다시 그려질 때 호출됨
    super.didChangeDependencies();
    _loadNickname(); // 닉네임을 다시 불러옴
  }

  void _loadNickname() async {
    // 닉네임을 불러오는 메서드 추가
    String? nickname = await _dbHelper.getNickname(widget.loginId);
    setState(() {
      _nickname = nickname ?? 'Unknown User'; // 닉네임을 초기화
    });
  }

  Future<void> _checkAndDisplayNotifications() async {
    //저장된 알림 메시지를 불러오기
    List<String> notifications =
        await NotificationService.getStoredNotifications();
    if (notifications.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('알림 메시지'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: notifications.map((message) => Text(message)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                NotificationService.clearNotifications(); // 메시지 확인 후 삭제 (옵션)
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      appBar: AppBar(
        backgroundColor: Colors.grey, // 앱바 배경색
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey), // 뒤로가기 버튼
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 프로필 섹션
              ProfileWidget(
                  nickname: _nickname ?? 'Unknown User'), // 닉네임 전달 시 null 처리
              // 하단 버튼 섹션
              Container(
                child: Container(
                  color: Colors.white,
                  width: 340.0, // 넓이를 기기 화면에 맞게 조정
                  padding: EdgeInsets.symmetric(horizontal: 16.0), //
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Column의 주 축에서 시작
                    // 가로로 꽉 차게
                    children: [
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileChange(
                                loginId: widget.loginId, //클래스다른데도 위에 있는 클래스에서
                                nickname:
                                    _nickname ?? 'Unknown User', // nickname 전달
                              ),
                            ), //widget.loginId로 수정
                          );
                        },
                        child: buildMenuItem(Icons.person, "프로필 이미지 변경"),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NicknameChange(
                                loginId: widget.loginId, // loginId 전달
                                nickname: _nickname ?? 'Unknown User',
                              ),
                            ),
                          ); // widget.loginId로 수정
                        },
                        child: buildMenuItem(Icons.sync, "닉네임 변경"),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordChange(
                                      loginId: widget.loginId, // loginId 전달
                                      nickname: _nickname ?? 'Unknown User',
                                    )),
                          );
                        },
                        child: buildMenuItem(Icons.lock, "비밀번호 변경"),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAccount(
                                loginId: widget.loginId,
                                nickname:
                                    _nickname ?? 'Unknown User', // nickname 전달
                              ),
                            ),
                          );
                        },
                        child: buildMenuItem(Icons.exit_to_app, "회원 탈퇴"),
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

  //메뉴 아이템 빌드 함수---페이지별로 위젯을 나눴어야 그페이지에 필요한 위젯 바로 볼 수 있었을것
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
