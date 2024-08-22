import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/account/loginscreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText2 = true;
  String? _errorMessage;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _loginIdController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _checkPasswords() {
    setState(() {
      if (_passwordController.text != _passwordController2.text) {
        _errorMessage = "비밀번호가 동일하지 않습니다.";
      } else {
        _errorMessage = null;
      }
    });
  }

  Future<void> _signup() async {
    if (_passwordController.text != _passwordController2.text) {
      setState(() {
        _errorMessage = "비밀번호가 동일하지 않습니다.";
      });
      return;
    }

    final dbHelper = DatabaseHelper();

    Map<String, dynamic> user = {
      'login_id': _loginIdController.text,
      'nickname': _nicknameController.text,
      'password': _passwordController.text,
    };

    try {
      await dbHelper.insertUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Error: $e");
      setState(() {
        _errorMessage = "회원가입에 실패했습니다. 다시 시도해주세요.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 가입을 해볼까요?"),
      ),
      body: SingleChildScrollView(
        //& 화면을 스크롤할 수 있도록 변경
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "회원가입",
                style: TextStyle(fontSize: 40),
              ),
            ),
            Form(
              key: formKey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: TextField(
                              controller: _loginIdController,
                              decoration: InputDecoration(
                                labelText: "ID         email 형식으로 작성해주세요.",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0XFFDBDAE3)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextField(
                              controller: _nicknameController,
                              decoration: InputDecoration(
                                labelText: "닉네임",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0XFFDBDAE3)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: "비밀번호",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0XFFDBDAE3)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _toggleVisibility,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                            child: TextFormField(
                              controller: _passwordController2,
                              obscureText: _obscureText2,
                              decoration: InputDecoration(
                                labelText: "비밀번호 확인",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0XFFDBDAE3)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _toggleVisibility2,
                                ),
                              ),
                              onChanged: (value) {
                                _checkPasswords();
                              },
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(370, 50),
                              backgroundColor: Color(0XFFFF672D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              _signup(); // 회원가입 요청
                            },
                            child: Text(
                              "가입하기",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
