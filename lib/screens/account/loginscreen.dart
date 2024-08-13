import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todomate/screens/account/introscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // 비밀번호 표시 상태
  TextEditingController _passwordController =
      TextEditingController(); // 비밀번호 컨트롤러
  bool _isCheckd = false;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText; // 비밀번호 표시 상태 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "환영합니다.",
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
          SizedBox(height: 100),
          TextField(
            decoration: InputDecoration(
              labelText: "아이디를 입력해 주세요.",
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: _obscureText, // 비밀번호 표시 설정
            decoration: InputDecoration(
              labelText: "비밀번호를 입력해 주세요.",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _toggleVisibility, // 버튼 클릭 시 비밀번호 표시 토글
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "암호를 잊어버렸습니다",
                      style: TextStyle(color: Colors.red),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(370, 50),
                  backgroundColor: Color(0XFFFF672D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isCheckd, // 체크박스의 현재 상태
                    onChanged: (value) {
                      setState(
                        () {
                          _isCheckd = value ?? false; // 체크박스 상태 업데이트
                        },
                      );
                    },
                  ),
                  Text(
                    "자동로그인",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                  ),
                  Text("계정이 없습니다."),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "회원가입",
                          style: TextStyle(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IntroScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 17, 10, 10),
                    width: 170,
                    height: 60,
                    color: Colors.yellow,
                    child: Text("카톡 로그인",
                    style: TextStyle(
                      fontSize: 20
                    ),),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 17, 10, 10),
                    width: 170,
                    height: 60,
                    color: Colors.blue,
                    child: Text("구글 로그인",
                      style: TextStyle(
                          fontSize: 20
                      ),),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "SNS 계정 로그인",
                      style: TextStyle(color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
