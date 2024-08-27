class ChatRoomModel {
  int? id;
  String name;
  int topicId;
  int userId;
  String startDate;
  String endDate;

  // 생성자
  ChatRoomModel({
    this.id,
    required this.name,
    required this.topicId,
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topicId': topicId,
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
