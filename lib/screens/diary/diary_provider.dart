import 'package:flutter/material.dart';

import '../../models/diary_model.dart';
import '../../models/signup_model.dart';
import '../../util/alert_dialog.dart';
import 'diary_detail_screen.dart';

class DiaryProvider extends ChangeNotifier {
  List<DiaryDTO> _diaryList = [];
  List<DiaryDTO> _selectedDiaryList = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusDay = DateTime.now();
  bool _isLoading = true;

  List<DiaryDTO> get diaryList => _diaryList;

  List<DiaryDTO> get selectedDiaryList => _selectedDiaryList;

  DateTime get selectedDay => _selectedDay;

  DateTime get focusDay => _focusDay;

  bool get isLoading => _isLoading;

  DiaryProvider() {
    // Provider 생성 시 초기 데이터 로딩
    loadDiaryDateList();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    setSelectedDiaryList();
    notifyListeners();
  }

  void setFocusDay(DateTime day) {
    _focusDay = day;
    notifyListeners();
  }

  Future<void> loadDiaryDateList() async {
    _isLoading = true;
    notifyListeners();

    _diaryList = await DatabaseHelper().getDiaryList();
    _isLoading = false;
    setSelectedDiaryList();
    notifyListeners();
  }

  void setSelectedDiaryList() {
    _selectedDiaryList = _diaryList
        .where((diary) =>
            diary.createAt ==
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day))
        .toList();
    notifyListeners();
  }

  bool checkDiaryDay(DateTime date) {
    return _diaryList.any((diary) => diary.createAt == date);
  }

  // 다이어리 상세 화면으로 이동
  Future<void> moveDetailScreen(BuildContext context, int index) async {
    final diary = _selectedDiaryList[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DiaryDetailScreen(diaryDTO: diary)),
    );

    if (result != null) {
      loadDiaryDateList();
    }
  }

  // 날짜 선택 시 호출되는 메서드
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusDay = focusedDay;
    setSelectedDiaryList();
  }

  Future<void> deleteDiary(BuildContext context, DiaryDTO diary) async {
    try {
      bool isSuccessDeleteDiary =
          await DatabaseHelper().deleteDiary(diary.id ?? 0);

      if (isSuccessDeleteDiary) {
        showAlertDialog(context, '알림', '삭제 되었습니다.');
        await loadDiaryDateList();
      } else {
        showAlertDialog(context, "알림", "삭제 실패했습니다.");
      }
    } catch (e) {
      showAlertDialog(context, '오류', '삭제 중 오류가 발생했습니다.');
    }
  }
}
