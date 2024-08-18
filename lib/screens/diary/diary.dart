import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/diary/diary_work_screen.dart';
import 'package:todomate/util/string_utils.dart';

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

  late List<DiaryDTO> _diaryList;
  List<DiaryDTO> _selectedDiaryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadDiaryDateList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '다이어리',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: _isLoading //로딩시 프로그래스 바
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DiaryWorkScreen(addScreen: true, date: _selectedDay)),
                              ).then((result) {
                                if (result != null) {
                                  // 데이터를 받아서 처리
                                  loadDiaryDateList(); // 데이터베이스에서 다시 데이터를 불러오는 메서드
                                }
                              });
                            },
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
                                  setSelectedDiaryList();
                                });
                              },
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                headerPadding:
                                    EdgeInsets.symmetric(vertical: 4.0),
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
                                  todayDecoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: const BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  markerDecoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  markersAlignment: Alignment.bottomCenter),
                              eventLoader: (day) {
                                if (checkDiaryDay(
                                    DateTime(day.year, day.month, day.day))) {
                                  return [1];
                                } else {
                                  return [];
                                }
                              },
                              calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, events) {
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
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ));
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),
                    _selectedDiaryList.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _selectedDiaryList.length,
                              itemBuilder: (context, index) {
                                final diary = _selectedDiaryList[index];
                                return Dismissible(
                                  key: Key(diary.createAt.toIso8601String()),
                                  // 고유한 키를 부여
                                  direction: DismissDirection.endToStart,
                                  // 항목을 오른쪽에서 왼쪽으로 밀어서 제거
                                  onDismissed: (direction) {
                                    setState(() {
                                      _selectedDiaryList
                                          .removeAt(index); // 항목을 리스트에서 제거
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('삭제되었습니다')),
                                    );
                                  },
                                  background: Container(
                                    color: Colors.redAccent,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Material(
                                        elevation: 5.0,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DiaryWorkScreen(
                                                          addScreen: false, diaryDTO: _selectedDiaryList[index], date: _selectedDiaryList[index].createAt,
                                                        ))); //todo 잘 넘어가나 확인
                                          },
                                          child: Chip(
                                            backgroundColor: Colors.white,
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: const BorderSide(
                                                  color: Colors.white),
                                            ),
                                            label: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.circle,
                                                        color: Colors
                                                            .deepOrangeAccent,
                                                        size: 12),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      dateToString(
                                                          diary.createAt),
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .deepOrangeAccent),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'tag', //todo hero tag 뭐지?
          onPressed: () {
            // 다이어리 추가
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DiaryWorkScreen(addScreen: true)),
            ).then((result) {
              if (result != null) {
                // 데이터를 받아서 처리
                loadDiaryDateList(); // 데이터베이스에서 다시 데이터를 불러오는 메서드
              }
            });
          },
          backgroundColor: Colors.deepOrangeAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        backgroundColor: Colors.white,
      ),
    );
  }

  //모든 일기 리스트 가져오기
  Future<void> loadDiaryDateList() async {
    _isLoading = true;

    _diaryList = await DatabaseHelper().getDiaryList();
    for (DiaryDTO diaryDTO in _diaryList) {
      print(diaryDTO.createAt);
    }
    setState(() {
      _isLoading = false;
      setSelectedDiaryList();
    });
  }

  //다이어리 쓴 날
  bool checkDiaryDay(DateTime date) {
    for (DiaryDTO diaryDTO in _diaryList) {
      if (diaryDTO.createAt == date) {
        return true;
      }
    }
    return false;
  }

  //선택된 날짜의 일기목록리스트
  void setSelectedDiaryList() {
    //초기화
    _selectedDiaryList = [];

    for (DiaryDTO diary in _diaryList) {
      if (diary.createAt ==
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)) {
        _selectedDiaryList.add(diary);
      }
    }
  }
}
