import 'package:flutter/foundation.dart';
import 'package:todomate/screens/chat_room/test_models.dart';
import 'package:todomate/models/signup_model.dart';

class ChatRoomProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<ChatRoomModel> _chatRooms = [];

  List<ChatRoomModel> get chatRooms => _chatRooms;

  Future<void> getChatRoomList() async {
    _chatRooms = await _db.getChatRoom();
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
