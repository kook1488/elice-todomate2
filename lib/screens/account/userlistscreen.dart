import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart'; // DatabaseHelper 클래스가 위치한 경로에 맞게 수정

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("사용자 목록"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("데이터를 불러오는 중 오류가 발생했습니다."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("저장된 사용자가 없습니다."));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['nickname']),
                  subtitle: Text('아이디: ${user['login_id']}, 패스워드: ${user['password']}'),
                );
              },
            );
          }
        },
      ),
    );
  }

}
