import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('채팅방 목록', style: TextStyle(fontSize: 18.0)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_sharp, color: Colors.black),
            onPressed: () {
              // TODO: Implement dropdown action
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[flutter study]',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        Text(
                          '테스트',
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '시작: 2024-08-15 15:54',
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                        ),
                        Text(
                          '종료: 2024-08-23 15:54',
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // `primary` 대신 `backgroundColor` 사용
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text(
                          '입장',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // `primary` 대신 `backgroundColor` 사용
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text(
                          '퇴장',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add action for FAB
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MY',
          ),
        ],
      ),
    );
  }
}
