import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todomate/screens/account/introscreen.dart';

void main() {
  //format 라이브러리 쓰기 위함
  initializeDateFormatting().then((_){
    runApp(const MaterialApp(
      home: IntroScreen(),
    ));
  });
}
