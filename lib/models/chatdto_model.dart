class ChatDTO{
  String id;
  String message;

  ChatDTO({required this.id, required this.message});

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
    };
  }

  // JSON을 객체로 변환하는 factory constructor
  factory ChatDTO.fromJson(Map<String, dynamic> json) {
    return ChatDTO(
      id: json['id'],
      message: json['message'],
    );
  }
}