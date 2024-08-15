import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todomate/api/api.dart';
import 'package:todomate/screens/account/findpwscreen.dart';
import 'package:todomate/screens/account/introscreen.dart';
import 'package:todomate/screens/account/signupscreen.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // 비밀번호 표시 상태
  TextEditingController _passwordController = TextEditingController(); // 비밀번호 컨트롤러
  TextEditingController _loginIdController = TextEditingController(); // 아이디 컨트롤러
  bool _isCheckd = false;
  String? _errorMessage;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText; // 비밀번호 표시 상태 토글
    });
  }

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse(API.login),
        body: {
          'login_id': _loginIdController.text,
          'password': _passwordController.text,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded', // Content-Type 헤더 설정
        },
      );

      print("Server response status code: ${response.statusCode}");
      print("Server response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
          );
        } else {
          setState(() {
            _errorMessage = jsonResponse['error'] ?? "로그인 실패. 다시 시도해 주세요.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "서버 오류: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _errorMessage = "네트워크 오류가 발생했습니다. 서버 주소와 네트워크를 확인해주세요.";
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                "환영합니다.",
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextField(
              controller: _loginIdController,
              decoration: InputDecoration(
                labelText: "아이디를 입력해 주세요.",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Color(0XFFDBDAE3)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscureText, // 비밀번호 표시 설정
              decoration: InputDecoration(
                labelText: "비밀번호를 입력해 주세요.",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Color(0XFFDBDAE3)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleVisibility, // 버튼 클릭 시 비밀번호 표시 토글
                ),
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
                                builder: (context) => FindPwScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20)
            ],
          ),
          SizedBox(height: 30),
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
                onPressed: () {
                  _login(); // 로그인 요청 함수 호출
                },
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isCheckd, // 체크박스의 현재 상태
                    onChanged: (value) {
                      setState(() {
                        _isCheckd = value ?? false; // 체크박스 상태 업데이트
                      });
                    },
                  ),
                  Text("자동로그인"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 140),
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
                                    builder: (context) => SignupScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 17, 10, 10),
                    width: 170,
                    height: 60,
                    color: Colors.yellow,
                    child: Text(
                      "카톡 로그인",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 17, 10, 10),
                    width: 170,
                    height: 60,
                    color: Colors.blue,
                    child: Text(
                      "구글 로그인",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
