class DiaryDTO{
  int? id;
  String userId;
  String title;
  String description;
  String? imageUrl;
  DateTime createAt;

  DiaryDTO({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createAt});

  // JSON 데이터를 Diary 객체로 변환하는 팩토리 생성자
  factory DiaryDTO.fromJson(Map<String, dynamic> json) {
    return DiaryDTO(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      createAt: DateTime.parse(json['createAt']),
    );
  }

  // Diary 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createAt': createAt.toIso8601String(),
    };
  }
}