import 'package:intl/intl.dart';

class ChatModel {
  ChatModel({
    required this.id,
    required this.image,
    required this.title,
    required this.name,
    required this.lastMessage,
    required this.date,
    required this.unread,
  });
  final int id;  
  final String image;
  final String title;
  final String name;
  final String lastMessage;
  final DateTime date;
  final int unread;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        name: json["name"],
        lastMessage: json["lastMessage"],
        date: DateTime.parse(json["date"]),
        unread: json["messagesCount"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "name": name,
        "lastMessage": lastMessage,
        "date": date.toIso8601String(),
        "messagesCount": unread,
      };

  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(date); // 요일
    } else {
      return DateFormat('MM/dd').format(date);
    }
  }
}

List<Map<String, dynamic>> itemsList = [
  {
    'id': 3,
    'image': 'assets/images/avata_3.png',
    'title': '플로터 스터디',
    'name': '조이',
    'lastMessage': '오늘 카페에 같이가자...',
    'date': '2024-08-15T10:02:00Z',
    'messagesCount': 1,
  },
  {
    'id': 4,
    'image': 'assets/images/avata_4.png',
    'title': '편의점 탐방',
    'name': '칼스버그',
    'lastMessage': '편의점 감밥 어디께 좋아...',
    'date': '2024-08-14T10:04:00Z',
    'messagesCount': 2,
  },
  {
    'id': 5,
    'image': 'assets/images/avata_5.png',
    'title': '목마와 맥주',
    'name': '디디',
    'lastMessage': '오늘 맥주한잔 하자...',
    'date': '2024-08-14T10:02:00Z',
    'messagesCount': 0,
  },
  {
    'id': 6,
    'image': 'assets/images/avata_6.png',
    'title': '게임 기획 연구',
    'name': '엉클',
    'lastMessage': '신규 게임 기획이 쉽지 않은것 같아...',
    'date': '2024-08-15T11:36:00',
    'messagesCount': 0,
  },
  {
    'id': 2,
    'image': 'assets/images/avata_2.png',
    'title': '이력서 리뷰',
    'name': '태권V',
    'lastMessage': '요즘 날씨에 운동하기 힘들지?...',
    'date': '2024-08-12T10:02:00Z',
    'messagesCount': 0,
  },
];

/* DB -- 채팅방 테이블
CREATE TABLE chats(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  image TEXT,
  title TEXT,
  pinned INTEGER,
  muted INTEGER,
  archived INTEGER,
  name TEXT,
  lastMessage TEXT,
  date TEXT,
  unread INTEGER
);
*/
