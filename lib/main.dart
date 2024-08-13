import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todomate/screens/account/introscreen.dart';

void main() async{
  await initializeDateFormatting();

  runApp(MaterialApp(
    home: IntroScreen(),
  ));
}
