import 'package:flutter/material.dart';

/// *
/// shouldPop => 페이지 종료
void showAlertDialog(BuildContext context, String title, String content, {bool shouldPop = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              if (shouldPop) {
                Navigator.of(context).pop(true); // 이전 화면으로 이동
              }
            },
            child: Text('확인'),
          ),
        ],
      );
    },
  );
}