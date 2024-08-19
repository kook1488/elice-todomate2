import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../models/diary_model.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() => DiaryCalendarScreenState();
}

class DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 60));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 60));
  final Map<DateTime, List<DiaryDTO>> _events = {};

  @override
  void initState() {
    super.initState();
    //데이터 긁어온 후 diary list 주입
    List<DiaryDTO> diaryList = [];
    DateTime sampleDate = _focusDay;
    diaryList.add(DiaryDTO(
        userId: "1",
        description: "!",
        imageUrl: "!",
        createAt: DateTime(sampleDate.year, sampleDate.month, sampleDate.day)));
    diaryList.add(DiaryDTO(
        userId: "1",
        description: "!",
        imageUrl: "!",
        createAt: DateTime(sampleDate.year, sampleDate.month, sampleDate.day)
            .add(const Duration(days: 5))));
    diaryList.add(DiaryDTO(
        userId: "1",
        description: "!",
        imageUrl: "!",
        createAt: DateTime(sampleDate.year, sampleDate.month, sampleDate.day)
            .subtract(const Duration(days: 5))));

    for (DiaryDTO dto in diaryList) {
      _events[dto.createAt] = [dto];
      print(dto.createAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('다이어리'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(16.0),
              child: TableCalendar(
                focusedDay: _focusDay,
                firstDay: _firstDay,
                lastDay: _lastDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusDay = focusedDay;
                    _selectedDay = selectedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                  ),
                  headerPadding: EdgeInsets.symmetric(vertical: 4.0),
                  leftChevronIcon: Icon(
                    Icons.arrow_left,
                    size: 30,
                    color: Colors.deepOrangeAccent,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_right,
                    size: 30,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    markersAlignment: Alignment.bottomCenter),
                eventLoader: (day) {
                  return _events[DateTime(day.year, day.month, day.day)] ?? [];
                },
                calendarBuilders:
                    CalendarBuilders(markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                        right: 5,
                        bottom: 1,
                        left: 5,
                        child: Container(
                          width: double.infinity,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ));
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
