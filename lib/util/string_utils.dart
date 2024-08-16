import 'package:intl/intl.dart';

// ####.#.# 형식 Format
String dateToString(DateTime day) => DateFormat.yMd('ko-KR').format(day);
