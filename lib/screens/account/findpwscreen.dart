import 'package:flutter/material.dart';
import 'package:todomate/screens/account/pwresetting.dart';

class FindPwScreen extends StatelessWidget {
  const FindPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("암호 찾기"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text("가입한 아이디를 입력해주세요",
                  style: TextStyle(
                      fontSize: 17
                  ),),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "email 형식으로 작성해주세요.",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0XFFDBDAE3)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text("전송",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0XFFF55721)), // 수정된 부분
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text("email로 전송된 번호 4자리를 입력해 주세요.",
                  style: TextStyle(
                      fontSize: 17
                  ),),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "****",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Color(0XFFDBDAE3)),
                  ),
                ),
              ),
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
                MaterialPageRoute(builder: (context) => const PwresettingScreen()),
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

