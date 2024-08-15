class MessageModel {
  final int id;
  final String sender;
  final int userId;
  final String? avatarImage;  // 아바타 이미지
  final String? attachedImage;  // 첨부된 이미지
  final String message;
  final DateTime timestamp;
  final bool read;

  MessageModel({
    required this.id,
    required this.sender,
    required this.userId,
    this.avatarImage,
    this.attachedImage,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: json['sender'],
      userId: json['userId'],
      avatarImage: json['avatarImage'],
      attachedImage: json['attachedImage'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'userId': userId,
    'avatarImage': avatarImage,
    'attachedImage': attachedImage,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'read': read,
  };
}