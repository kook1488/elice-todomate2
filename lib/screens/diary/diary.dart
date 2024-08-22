import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todomate/screens/diary/diary_add_screen.dart';

import 'package:todomate/util/string_utils.dart';

import 'diary_provider.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  _DiaryCalendarScreenState createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 일기 목록을 가져옵니다.
    Future.microtask(() =>
        Provider.of<DiaryProvider>(context, listen: false).loadDiaryDateList());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, diaryProvider, child) {
        if (diaryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('다이어리', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0)),
                      child: GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiaryAddScreen(
                                    date: diaryProvider.selectedDay)),
                          ).then((result) {
                            if (result != null) {
                              diaryProvider.loadDiaryDateList();
                            }
                          });
                        },
                        child: TableCalendar(
                          focusedDay: diaryProvider.focusDay,
                          firstDay:
                              DateTime.now().subtract(const Duration(days: 60)),
                          lastDay: DateTime.now().add(const Duration(days: 60)),
                          selectedDayPredicate: (day) {
                            return isSameDay(diaryProvider.selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            diaryProvider.onDaySelected(
                                selectedDay, focusedDay);
                          },
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                            if (diaryProvider.checkDiaryDay(
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
                            },
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                diaryProvider.selectedDiaryList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: diaryProvider.selectedDiaryList.length,
                          itemBuilder: (context, index) {
                            final diary =
                                diaryProvider.selectedDiaryList[index];
                            return Dismissible(
                              key: Key(diary.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                await diaryProvider.deleteDiary(context, diary);
                              },
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: GestureDetector(
                                      onTap: () => diaryProvider
                                          .moveDetailScreen(context, index),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.circle,
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    size: 12),
                                                const SizedBox(width: 10),
                                                Text(
                                                  dateToString(diary.createAt),
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
                    : const SizedBox()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiaryAddScreen(date: diaryProvider.selectedDay)),
              ).then((result) {
                if (result != null) {
                  diaryProvider.loadDiaryDateList();
                }
              });
            },
            backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
