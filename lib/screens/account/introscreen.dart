import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todomate/chat/view/chats_screen.dart';
import 'package:todomate/screens/account/loginscreen.dart';
import 'package:todomate/util/sharedpreference.dart';

import '../../chat/models/user_info.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double _fillRatio = 0.0;
  bool _isCompleted = false;
  Timer? _timer;
  bool _isAutoLogin = false;
  late UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    getIsAutoLogin();
    _startAnimation();
  }

  void _startAnimation() {
    _fillRatio = 0.0;
    _isCompleted = false;
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        if (_fillRatio < 1.0) {
          _fillRatio += 0.01;
        } else {
          _isCompleted = true;
          _timer?.cancel();
          _navigateToLoginScreen();
        }
      });
    });
  }

  void _navigateToLoginScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        _isAutoLogin ?
          MaterialPageRoute(builder: (context) => ChatsScreen(userInfo: _userInfo!))
            : MaterialPageRoute(builder: (context) => LoginScreen())
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 위젯이 dispose될 때 타이머 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'asset/image/intro.png',
              width: 430,
              height: 800,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 배터리 박스
                  Container(
                    width: 200, // 배터리의 너비
                    height: 30, // 배터리의 높이
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        // 초록색으로 채워지는 부분
                        Positioned(
                          left: 0,
                          child: Container(
                            width: _fillRatio * 200, // 배터리의 너비에 비례
                            height: 30,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 체크 표시
                  if (_isCompleted)
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getIsAutoLogin() async {
    //todo boolean값 넣을수 있게
    String isAutoLogin = await TodoSharedPreference().getPreferenceWithKey("isAutoLogin");
    if(isAutoLogin.isEmpty){
      _isAutoLogin = false;
    }else{
      _isAutoLogin = bool.parse(isAutoLogin);
    }

    if(_isAutoLogin){//자동로그인이라면
      String id = await TodoSharedPreference().getPreferenceWithKey("id");
      String nickName = await TodoSharedPreference().getPreferenceWithKey("nickName");
      String avatarPath = await TodoSharedPreference().getPreferenceWithKey("avatarPath");
      String loginId = await TodoSharedPreference().getPreferenceWithKey("userId");
      _userInfo = UserInfo(id: int.parse(id), nickName: nickName, avatarPath: avatarPath, loginId: loginId);
    }else{
      _userInfo = null;
    }
  }
}
