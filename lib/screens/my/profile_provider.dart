import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';
import 'package:todomate/util/notification_service.dart';

class ProfileProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // DB 불러옴
  String? _nickname;
  String _avatarPath = 'asset/image/avata_1.png'; // 기본 아바타 경로로 초기화
  bool _isNicknameLoaded = false; // 닉네임 로딩 상태 추가
  bool _isUpdatingNickname = false; // 닉네임 업데이트 중인지 여부를 나타내는 플래그 추가
// 프로바이더가 초기화 되는 상황
// 마이 페이지 눌렀을때 디비에서 초기화함.
  int _todoCount = 7;
  int _completedTodoCount = 5;
  int _diaryCount = 0;
  int _friendCount = 0;
  int _activeChatCount = 0;
  int _reservedChatCount = 0;

  // Getter 메서드
  String? get nickname => _nickname;

  String get avatarPath => _avatarPath;

  bool get isNicknameLoaded => _isNicknameLoaded; // 로딩 상태 Getter 추가

  int get todoCount => _todoCount;

  int get completedTodoCount => _completedTodoCount;

  int get diaryCount => _diaryCount;

  int get friendCount => _friendCount;

  int get activeChatCount => _activeChatCount;

  int get reservedChatCount => _reservedChatCount;
/////////koo 채팅방 예약개수 +1
  void incrementReservedChatCount() {
    _reservedChatCount++;
    notifyListeners();
  }

//줄이는건 필요없지 않나?
  void decrementReservedChatCount() {
    if (_reservedChatCount > 0) {
      _reservedChatCount--;
      notifyListeners();
    }
  }

  //데이터베이스에서 닉네임 가져옴
  Future<void> loadNickname(String loginId) async {
    if (_isNicknameLoaded || _isUpdatingNickname)
      return; // 이미 닉네임이 로드되었거나 업데이트 중이라면 중단
    _nickname = await _dbHelper.getNickname(loginId);
    _isNicknameLoaded = true; // 닉네임이 로드되었음을 표시
    notifyListeners();
  }

  Future<void> justloadNickname(String loginId) async {
    _nickname = await _dbHelper.getNickname(loginId);
    // 닉네임이 로드되었음을 표시
    notifyListeners();
  }

////////////////////////////////////
//[2]버튼 눌린 후 닉네임 업데이트
  Future<void> updateNickname(String loginId, String newNickname) async {
    // 1. 현재 닉네임과 새 닉네임이 동일하지 않은지 확인
    if (_nickname == null || _isUpdatingNickname) return;
    if (_nickname == newNickname) return;

    _isUpdatingNickname = true; // 닉네임 업데이트 중 상태 플래그 설정
    // 2. 데이터베이스에서 닉네임을 업데이트
    await _dbHelper.updateNickname(loginId, newNickname);
    // 3. 닉네임을 새 값으로 업데이트
    _nickname = newNickname;
    _isNicknameLoaded = true;
    _isUpdatingNickname = false;
    // 4. 상태 변경 알림
    notifyListeners();
  }

///////////////////////////////////////
  // 아바타 이미지 변경
  Future<void> updateAvatarPath(String loginId, String newAvatarPath) async {
    _avatarPath = newAvatarPath; // 새로운 프로필 이미지 경로를 설정
    notifyListeners();
  }

  // 각 상태를 업데이트하는 메서드 추가
  void updateTodoCount(int count) {
    _todoCount = count;
    notifyListeners();
  }

  void updateCompletedTodoCount(int count) {
    _completedTodoCount = count;
    notifyListeners();
  }

//다이어리 카운트
  void updateDiaryCount(int count) {
    _diaryCount += count;
    notifyListeners();
  }

  // 채팅방 개수 업데이트 (ChatRoomProvider와 연동)
  Future<void> updateActiveChatCount(ChatRoomProvider chatRoomProvider) async {
    //& ChatRoomProvider와 연동하여 채팅방 개수 업데이트
    await chatRoomProvider
        .getChatRoomList([]); // ChatRoomProvider에서 최신 채팅방 목록을 가져옴
    _activeChatCount = chatRoomProvider
        .activeChatCount; // ChatRoomProvider의 activeChatCount를 사용
    // notifyListeners(); -이거 주석처리 했더니 무한호출이 해결됨
  } // 왜 해결 됬을까?

//예약된 채팅방 개수
  void updateReservedChatCount(int count) {
    _reservedChatCount = count;
    notifyListeners();
  }

  // 친구 수 업데이트 메서드
  void updateFriendCount(int count) {
    _friendCount = count;
    notifyListeners();
  }

  // 친구 추가 시 호출할 메서드
  void addFriend() {
    _friendCount += 1;
    notifyListeners();
  }

  // 친구 삭제 시 호출할 메서드
  void removeFriend() {
    if (_friendCount > 0) {
      _friendCount -= 1;
      notifyListeners();
    }
  }

  //kook [3] 알림
  //[1]친구에게 닉네임 변경 알림 시작
  // 닉네임 변경 정보를 로컬 데이터베이스에 저장하는 메서드
  Future<void> saveNicknameChangeForFriends(
      String loginId, String newNickname) async {
    String oldNickname = _nickname ?? '';
    // 닉네임 변경 정보를 로컬 데이터베이스에 저장 //
    await _dbHelper.saveNicknameChange(loginId, oldNickname, newNickname);
    // 친구들에게 알림을 보내는 로직은 나중에 친구가 마이프로필을 열 때 실행됩니다.
  }

  //닉네임 변경 알림
  // 친구가 마이프로필을 열 때 닉네임 변경 알림을 보내는 메서드
  // 로컬 데이터베이스에서 닉네임 변경 정보를 가져옴
  Future<void> notifyNicknameChange(List<String> acceptedFriends) async {
    // friendId 대신 acceptedFriends 사용
    for (var friendId in acceptedFriends) {
      List<Map<String, dynamic>> changes =
          await _dbHelper.getNicknameChangesForFriend(friendId);
      for (var change in changes) {
        await NotificationService.sendNicknameChangeNotification(
          oldNickname: change['oldNickname'],
          newNickname: change['newNickname'],
          friendId: friendId,
        );
      }

      // 알림 전송 후 해당 변경 정보를 로컬 데이터베이스에서 삭제 //
      await _dbHelper.clearNicknameChangesForFriend(friendId);
    }
  }
}
