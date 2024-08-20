// import 'package:flutter/foundation.dart';
// import 'package:todomate/models/diary_model.dart'; // 다이어리 모델 경로를 맞춰주세요
// import 'package:todomate/models/signup_model.dart'; // DatabaseHelper 경로를 맞춰주세요
//
// class DiaryProvider with ChangeNotifier {
//   List<DiaryDTO> _diaries = [];
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//
//   List<DiaryDTO> get diaries => _diaries;
//
//   // 다이어리 개수를 반환하는 getter
//   int get diaryCount => _diaries.length;
//
//   Future<void> loadDiaries(String userId) async {
//     _diaries = await _databaseHelper.getDiaryList(userId); // 사용자 ID를 기반으로 다이어리 불러옴
//     notifyListeners();
//   }
//
//   Future<void> addDiary(DiaryDTO diary) async {
//     await _databaseHelper.insertDiary(diary);
//     _diaries.add(diary);
//     notifyListeners();
//   }
//
//   Future<void> deleteDiary(int diaryId) async {
//     await _databaseHelper.deleteDiary(diaryId);
//     _diaries.removeWhere((diary) => diary.id == diaryId);
//     notifyListeners();
//   }
// }
