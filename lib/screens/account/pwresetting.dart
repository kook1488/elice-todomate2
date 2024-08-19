import 'package:flutter/material.dart';
import 'package:todomate/screens/account/loginscreen.dart';

class PwresettingScreen extends StatefulWidget {
  const PwresettingScreen({super.key});

  @override
  State<PwresettingScreen> createState() => _PwresettingScreenState();
}

class _PwresettingScreenState extends State<PwresettingScreen> {
  bool _obscureText = true; // 비밀번호 표시 상태
  bool _obscureText2 = true;
  String? _errorMessage;
  TextEditingController _passwordController =
  TextEditingController(); // 비밀번호 컨트롤러

  TextEditingController _passwordController2 =
  TextEditingController(); // 비밀번호 컨트롤러

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText; // 비밀번호 표시 상태 토글
    });
  }
  void _toggleVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2; // 비밀번호 표시 상태 토글
    });
  }
  void _checkPasswords() {
    setState(() {
      if (_passwordController.text != _passwordController2.text) {
        _errorMessage = "비밀번호가 동일하지 않습니다.";
      } else {
        _errorMessage = null; // 비밀번호가 동일할 경우 에러 메시지 초기화
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("암호 재설정"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text("새로운 암호를 입력하세요.",
                  style: TextStyle(
                      fontSize: 17
                  ),),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscureText, // 비밀번호 표시 설정
              decoration: InputDecoration(
                labelText: "비밀번호",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: TextFormField(
              controller: _passwordController2,
              obscureText: _obscureText2, // 비밀번호 표시 설정
              decoration: InputDecoration(
                labelText: "비밀번호 확인",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Color(0XFFDBDAE3)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleVisibility2, // 버튼 클릭 시 비밀번호 표시 토글
                ),
              ),
              onChanged: (value) {
                _checkPasswords(); // 입력값이 변경될 때마다 비밀번호 확인
              },
            ),
          ),
          if (_errorMessage != null) // 에러 메시지가 있을 경우 출력
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text(
              "암호 재설정하기",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 400,),
        ],
      ),
    );
  }
}
