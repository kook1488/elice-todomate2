import 'package:flutter/material.dart';

class Filter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoomFilterPage(),
    );
  }
}

class RoomFilterPage extends StatelessWidget {
  final List<Map<String, dynamic>> rooms = [
    {'title': '스터디방', 'color': Colors.blue, 'count': 5},
    {'title': '공부방', 'color': Colors.grey[500], 'count': 3},
    // 다른 방 정보 추가 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('필터', style: TextStyle(fontSize: 18.0)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.blue),
            onPressed: () {
              // 완료 버튼 액션 구현
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 뒤로 가기 구현
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 열의 개수
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 3 / 2, // 항목의 가로 세로 비율
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];
            return _buildFilterCard(
                room['title'], room['color'], room['count']);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 플로팅 액션 버튼 액션 구현
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildFilterCard(String title, Color color, int count) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.red),
                  onPressed: () {
                    // 알림 설정 버튼 액션
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    // 삭제 버튼 액션
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
