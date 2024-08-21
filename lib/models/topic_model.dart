class TopicModel {
  int? id;
  String name;
  DateTime? startedAt;
  DateTime? endedAt;

  // 생성자
  TopicModel({
    this.id,
    required this.name,
    this.startedAt,
    this.endedAt,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }
}
