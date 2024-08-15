class ChatModel {
  ChatModel({
    required this.image,
    required this.title,
    required this.pinned,
    required this.muted,
    required this.archived,
    required this.name,
    required this.lastMessage,
    required this.date,
    required this.unread,
  });

  final String image;
  final String title;
  final bool pinned;
  final bool muted;
  final bool archived;
  final String name;
  final String lastMessage;
  final String date;
  final int unread;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        image: json["image"],
        title: json["title"],
        pinned: json["pinned"],
        muted: json["muted"],
        archived: json["archived"],
        name: json["name"],
        lastMessage: json["lastMessage"],
        date: json["date"],
        unread: json["messagesCount"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "pinned": pinned,
        "muted": muted,
        "archived": archived,
        "name": name,
        "lastMessage": lastMessage,
        "date": date,
        "messagesCount": unread,
      };
}

List<Map<String, dynamic>> itemsList = [
  {
    'image': 'assets/images/avata_3.png',
    'title': '플로터 스터디',
    'pinned': true,
    'muted': false,
    'archived': false,
    'name': '영희',
    'lastMessage': '오늘 카페에 같이가자...',
    'date': '11:36',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_1.png',
    'title': '게임 기획 연구',
    'pinned': false,
    'muted': false,
    'archived': false,
    'name': '민수',
    'lastMessage': '신규 게임 기획이 쉬지 않은것 같아...',
    'date': '11:25',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_2.png',
    'title': '이력서 리뷰',
    'pinned': false,
    'muted': true,
    'archived': true,
    'name': '명수',
    'lastMessage': '최근에 면접본데 괜찮았어?...',
    'date': '10:47',
    'messagesCount': 0,
  },
    {
    'image': 'assets/images/avata_3.png',
    'title': '플로터 스터디',
    'pinned': true,
    'muted': false,
    'archived': false,
    'name': '영희',
    'lastMessage': '오늘 카페에 같이가자...',
    'date': '11:36',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_1.png',
    'title': '게임 기획 연구',
    'pinned': false,
    'muted': false,
    'archived': false,
    'name': '민수',
    'lastMessage': '신규 게임 기획이 쉬지 않은것 같아...',
    'date': '11:25',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_2.png',
    'title': '이력서 리뷰',
    'pinned': false,
    'muted': true,
    'archived': true,
    'name': '명수',
    'lastMessage': '최근에 면접본데 괜찮았어?...',
    'date': '10:47',
    'messagesCount': 0,
  },
    {
    'image': 'assets/images/avata_3.png',
    'title': '플로터 스터디',
    'pinned': true,
    'muted': false,
    'archived': false,
    'name': '영희',
    'lastMessage': '오늘 카페에 같이가자...',
    'date': '11:36',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_1.png',
    'title': '게임 기획 연구',
    'pinned': false,
    'muted': false,
    'archived': false,
    'name': '민수',
    'lastMessage': '신규 게임 기획이 쉬지 않은것 같아...',
    'date': '11:25',
    'messagesCount': 2,
  },
  {
    'image': 'assets/images/avata_2.png',
    'title': '이력서 리뷰',
    'pinned': false,
    'muted': true,
    'archived': true,
    'name': '명수',
    'lastMessage': '최근에 면접본데 괜찮았어?...',
    'date': '10:47',
    'messagesCount': 0,
  },
];
