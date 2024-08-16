import 'package:flutter/material.dart';

class DiaryAddScreen extends StatefulWidget {
  const DiaryAddScreen({super.key});

  @override
  _DiaryAddScreenState createState() => _DiaryAddScreenState();
}

class _DiaryAddScreenState extends State<DiaryAddScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: '즐거운 하루');
  final TextEditingController _locationController =
      TextEditingController(text: '홍대 어딘가');
  final TextEditingController _dateController =
      TextEditingController(text: '2024. 08. 13');
  final TextEditingController _contentController =
      TextEditingController(text: '홍대 길거리 공연을 보고 재미있었다.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '다이어리',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Material(
              elevation: 4.0,
              // 원하는 elevation 값을 설정합니다.
              borderRadius: BorderRadius.circular(8),
              // Material의 모서리를 TextField와 동일하게 맞춥니다.
              shadowColor: Colors.black54,
              // 그림자 색상을 설정합니다.
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Material(
              elevation: 4.0,
              // 원하는 elevation 값을 설정합니다.
              borderRadius: BorderRadius.circular(8),
              // Material의 모서리를 TextField와 동일하게 맞춥니다.
              shadowColor: Colors.black54,
              // 그림자 색상을 설정합니다.
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Material(
              elevation: 4.0,
              // 원하는 elevation 값을 설정합니다.
              borderRadius: BorderRadius.circular(8),
              // Material의 모서리를 TextField와 동일하게 맞춥니다.
              shadowColor: Colors.black54,
              // 그림자 색상을 설정합니다.
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Material(
                elevation: 4.0,
                // 원하는 elevation 값을 설정합니다.
                borderRadius: BorderRadius.circular(8),
                // Material의 모서리를 TextField와 동일하게 맞춥니다.
                shadowColor: Colors.black54,
                // 그림자 색상을 설정합니다.
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('수정',
                    style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('삭제',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '',
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
