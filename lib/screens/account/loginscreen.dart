import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todomate/chat/models/user_info.dart';
import 'package:todomate/chat/view/chats_screen.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/account/findpwscreen.dart';
import 'package:todomate/screens/account/signupscreen.dart';
import 'package:todomate/screens/account/userlistscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _loginIdController = TextEditingController();
  bool _isChecked = false;
  String? _errorMessage;
  UserInfo? _userInfo;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });

    try {

      final loginResult = await _databaseHelper.loginUser(
        _loginIdController.text,
        _passwordController.text,
      );

      if (loginResult['success']) {
        final user = loginResult['user'];
        _userInfo = UserInfo(
          id: user['id'],
          nickName: user['nickname'],
          avatarPath: user['avatar_path'],
          loginId: _loginIdController.text, // loginId를 추가합니다.
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatsScreen(userInfo: _userInfo!),
          ),
        );
      } else {
        setState(() {
          _errorMessage = loginResult['message'] ?? "로그인에 실패했습니다.";
        });
      }
    } catch (e) {
      print("Error during login: $e");
      setState(() {
        _errorMessage = "로그인 중 오류가 발생했습니다. 다시 시도해주세요.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
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
                obscureText: _obscureText,
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
                    onPressed: _toggleVisibility,
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
                  onPressed: _login,
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
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Text("자동로그인"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                  builder: (context) => UserListScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
