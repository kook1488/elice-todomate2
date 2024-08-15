import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryCalendarScreen extends StatelessWidget {
  const DiaryCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.now().subtract(const Duration(days: 60)),
            lastDay: DateTime.now().add(const Duration(days: 60)),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: false,
              titleTextStyle: TextStyle(
                color: Colors.black,
              ),
              headerPadding: EdgeInsets.symmetric(vertical: 4.0),
              leftChevronIcon: const Icon(
              Icons.arrow_left,
              size: 40.0,
            ), // 아이콘 숨기기
              rightChevronIcon: SizedBox.shrink(), // 아이콘 숨기기
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMM('ko-KR').format(day),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.arrow_left),
                        SizedBox(width: 8.0),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
