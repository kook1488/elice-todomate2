import 'package:flutter/material.dart';
import 'package:todomate/models/diary_model.dart';

class DiaryWorkScreen extends StatefulWidget {
  DiaryDTO? diaryDTO;
  DateTime? date;
  bool addScreen; //true -> 추가 화면, false -> 수정 삭제 화면

  DiaryWorkScreen({super.key, this.diaryDTO, this.date, required this.addScreen});

  @override
  _DiaryWorkScreenState createState() => _DiaryWorkScreenState();
}

class _DiaryWorkScreenState extends State<DiaryWorkScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _imageController;
  late TextEditingController _contentController;


  @override
  void initState() {
    super.initState();
    if(widget.addScreen){
      _titleController = TextEditingController();
      _imageController = TextEditingController();
      _dateController = TextEditingController(text: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString());
      _contentController = TextEditingController();
    }else{//todo 데이터바꾸기
      _titleController = TextEditingController(text: widget.diaryDTO?.userId);
      _imageController = TextEditingController(text: widget.diaryDTO?.userId);
      _dateController = TextEditingController(text: widget.diaryDTO?.userId);
      _contentController = TextEditingController(text: widget.diaryDTO?.userId);
    }

  }

  @override
  Widget build(BuildContext context) {
    if(widget.addScreen){
      //추가화면
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '일기 쓰기',
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
                    hintText: '제목',
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
                    hintText: '날짜',
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
                  controller: _imageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '기본 이미지',
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
                      hintText: '오늘 있었던 일을 적어보세요.',
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
              ElevatedButton(
                onPressed: () {
                  // 등록 버튼 클릭 시 처리할 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      );
    }else{
      //수정삭제 화면 //todo 수정삭제화면
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '일기 쓰기',
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
        backgroundColor: Colors.white,
      );
    }

  }
}
