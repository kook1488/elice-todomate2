import 'package:flutter/foundation.dart';
import 'package:todomate/models/chat_room_model.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/models/topic_model.dart';

class ChatRoomProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<ChatRoomModel> _chatRooms = [];

  List<ChatRoomModel> get chatRooms => _chatRooms;

  //& 생성된 채팅방 개수를 반환하는 getter 추가
  int get activeChatCount => _chatRooms.length;

  Future<void> getChatRoomList(List<int> filterList) async {
    _chatRooms = await _db.getChatRoom(filterList);
    notifyListeners();
  }

  Future<void> updateChatRoomDetail(ChatRoomModel chatRoom) async {
    await _db.updateChatRoomModel(chatRoom);
    notifyListeners();
  }

  List<TopicModel> _topics = [];

  List<TopicModel> get topics => _topics;

  Future<void> getTopicList() async {
    _topics = await _db.getTopic();
    notifyListeners();
  }
}
