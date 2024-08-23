import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';

class ProfileProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // DB 불러옴
  String? _nickname;
  String _avatarPath = 'asset/image/avata_1.png'; // 기본 아바타 경로로 초기화
  bool _isNicknameLoaded = false; // 닉네임 로딩 상태 추가
  bool _isUpdatingNickname = false; // 닉네임 업데이트 중인지 여부를 나타내는 플래그 추가
  // 프로필 관련 상태
//프로바이더가 초기화 되는 시점이 그 화면을 가야만
// 프로바이더가 초기화 되는 상황
//프로바이더가
  //마이 페이지 눌렀을때 디비에서 초기화함.
  int _todoCount = 7;
  int _completedTodoCount = 5;
  int _diaryCount = 0;
  int _friendCount = 0;
  int _activeChatCount = 0;
  int _reservedChatCount = 2;

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

  // 데이터베이스에서 닉네임 가져옴
  Future<void> loadNickname(String loginId) async {
    if (_isNicknameLoaded || _isUpdatingNickname)
      return; // 이미 닉네임이 로드되었거나 업데이트 중이라면 중단
    _nickname = await _dbHelper.getNickname(loginId);
    _isNicknameLoaded = true; // 닉네임이 로드되었음을 표시
    notifyListeners(); // 상태가 변경되었음을 알림
  }

//닉네임 업데이트
  Future<void> updateNickname(String loginId, String newNickname) async {
    if (_nickname == null || _isUpdatingNickname)
      return; // 현재 닉네임이 없거나 업데이트 중이면 중단
    if (_nickname == newNickname) return; // 기존 닉네임과 같으면 중단

    _isUpdatingNickname = true; // 닉네임 업데이트 플래그 설정
    await _dbHelper.updateNickname(loginId, newNickname); // 데이터베이스에서 닉네임 업데이트

    _nickname = newNickname; // 닉네임 상태 업데이트
    _isNicknameLoaded = true;
    _isUpdatingNickname = false;
    notifyListeners(); // 상태가 변경되었음을 알림
  }
  // List<String> friendIds =
  //     await _dbHelper.getFriendIds(loginId); // 친구 목록 가져오기
  //
  // for (String friendId in friendIds) {
  //   //친구들에게 알림 보내기
  //   await NotificationService.sendNicknameChangeNotification(
  //       oldNickname: oldNickname, newNickname: newNickname);
  // }

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
    // notifyListeners();
  } //받고... 왜 해결 됬을까?

  void updateReservedChatCount(int count) {
    _reservedChatCount = count;
    notifyListeners();
  }

  // 친구 수 업데이트 메서드
  void updateFriendCount(int count) {
    _friendCount = count;
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  // 친구 추가 시 호출할 메서드 (예시)
  void addFriend() {
    _friendCount += 1;
    notifyListeners();
  }

  // 친구 삭제 시 호출할 메서드 (예시)
  void removeFriend() {
    if (_friendCount > 0) {
      _friendCount -= 1;
      notifyListeners();
    }

// 기타 필요한 메서드들 추가 가능
  }
}
