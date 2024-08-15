import 'package:flutter/material.dart';

//이거 무한 생성되야함 나중에 코드 읽고 고칠것
//**[프론트]**
// 1. mixin 클래스를 만들고 ScrollController를 속성으로 갖게합니다.
// 2. 아래 코드를 참고하여 ScrollController에 _onScroll()함수를 listener로 추가합니다.
// 3. 채팅방 목록뷰 위젯에 생성한 mixin을 활용하고, onScroll()를 overriding하여 목록을 추가로드할 수 있도록 합니다.
// 목록 추가로드는 페이징 혹은 커서링 방식으로 구현합니다.
class friendlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FriendSearchPage(),
    );
  }
}

class FriendSearchPage extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {'name': '스티븐', 'image': 'asset/image/avata_1.png'},
    {'name': '존', 'image': 'asset/image/avata_2.png'},
    {'name': '제임스', 'image': 'asset/image/avata_3.png'},
    {'name': '마이클', 'image': 'asset/image/avata_4.png'},
    {'name': '엘리자베스', 'image': 'asset/image/avata_5.png'},
  ]; // 친구 이름과 이미지 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 구현
          },
        ),
        title: Text('친구 찾기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 16.0),
            Text('친구 리스트',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children:
                    friends.map((friend) => _buildFriendCard(friend)).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.orange),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.orange),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.orange),
            label: '',
          ),
        ],
      ),
    );
  }

  // 검색 바 생성 함수
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cardiologist',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 친구 카드 생성 함수
  Widget _buildFriendCard(Map<String, String> friend) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.0,

              backgroundImage: AssetImage(friend['image']!), // 친구 아바타 이미지
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(friend['name']!, style: TextStyle(fontSize: 16.0)),
            ),
            IconButton(
              icon: Icon(Icons.close_sharp, color: Colors.orange), // 아이콘은 흰색
              onPressed: () {
                // 삭제 액션 구현
              },
            ),
          ],
        ),
      ),
    );
  }
}
