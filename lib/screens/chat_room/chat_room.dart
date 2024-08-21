import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todomate/models/chat_room_model.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/models/topic_model.dart';
import 'package:todomate/screens/chat/chat.dart';
import 'package:todomate/screens/chat_room/chat_room_provider.dart';
import 'package:todomate/screens/chat_room/chat_room_detail.dart';
import 'package:todomate/screens/chat_room/create_chat_room.dart';
import 'package:todomate/screens/chat_room/test_models.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final DatabaseHelper db = DatabaseHelper();
  late Future<List<ChatRoomModel>> chatRooms;
  late Future<List<TopicModel>> topics;
  late Future<String> topicName;
  late Future<String> topicDetail;
  late String nameString;
  late int topicId;
  bool isReserveDisable = false;
  bool isParticipateDisable = false;
  List<int> filterList = [];

  @override
  void initState() {
    super.initState();

    // chatRooms = db.getChatRoom(filterList);
    Provider.of<ChatRoomProvider>(context, listen: false)
        .getChatRoomList(filterList);

    // topics = db.getTopic();
    Provider.of<ChatRoomProvider>(context, listen: false).getTopicList();
  }

  // 채팅방 상세 페이지로 이동
  void _onChatRoomDetailTap(ChatRoomModel detail) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ChatRoomDetailScreen(chatRoomDetail: detail),
      ),
    )
        .then((onValue) {
      if (onValue) {
        Provider.of<ChatRoomProvider>(context, listen: false)
            .getChatRoomList(filterList);
        // chatRooms = db.getChatRoom(filterList);
        setState(() {});
      }
    });
  }

  // 채팅방 등록
  void _onCreateChatRoomTap() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const CreateChatRoomScreen(),
      ),
    )
        .then((onValue) {
      if (onValue) {
        Provider.of<ChatRoomProvider>(context, listen: false)
            .getChatRoomList(filterList);
        setState(() {});
      }
    });
  }

  // 채팅방 참여
  void _onParticipateChatTap() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    )
        .then((onValue) {
      if (onValue) {
        Provider.of<ChatRoomProvider>(context, listen: false)
            .getChatRoomList(filterList);
        setState(() {});
      }
    });
  }

  // 토픽 선택
  void _onTopicDetailTap(TopicModel detail) {
    topicId = detail.id!.toInt();
    if (filterList.where((item) => item == topicId).isEmpty) {
      filterList.add(topicId);
    } else {
      filterList.remove(topicId);
    }
    setState(() {});
    print(filterList);
  }

  Future<String> _topicName(int id) async {
    topicName = db.getTopicDetailName(topicId: id);
    nameString = await topicName;
    return nameString.toString();
  }

  bool _reserveButtonDisable(String date) {
    DateTime now = DateTime.now();
    isReserveDisable = DateTime.parse(date).isAfter(now);
    return isReserveDisable;
  }

  bool _participateButtonDisable(String date) {
    DateTime now = DateTime.now();
    isParticipateDisable = DateTime.parse(date).isAfter(now);
    return isParticipateDisable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('채팅방 목록'),
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.filter,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: SizedBox(
                        height: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    '주제를 선택하세요.',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Consumer<ChatRoomProvider>(
                                  builder: (context, topicProvider, child) {
                                final topicList = topicProvider.topics;
                                return SizedBox(
                                  height: 70,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: topicList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 70,
                                              // height: 70,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: GestureDetector(
                                                onTap: () => _onTopicDetailTap(
                                                    topicList[index]),
                                                child: Center(
                                                  child: Text(
                                                    topicList[index].name,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).then((onValue) {
                  Provider.of<ChatRoomProvider>(context, listen: false)
                      .getChatRoomList(filterList);
                  setState(() {});
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // FutureBuilder(
                  //   future: chatRooms,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else {
                  //       List<ChatRoomModel> chatRoomList =
                  //           snapshot.data as List<ChatRoomModel>;
                  //       return ListView.builder(
                  //         itemCount: chatRoomList.length,
                  //         itemBuilder: (context, index) {
                  //           return GestureDetector(
                  //             onTap: () => _onChatRoomDetailTap(
                  //                 chatRoomList[index]),
                  //             child: ListTile(
                  //               title: Container(
                  //                 height: 155,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                       color: Colors.grey.shade300),
                  //                 ),
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                     horizontal: 15,
                  //                     vertical: 10,
                  //                   ),
                  //                   child: Column(
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           // 주제를 비동기적으로 받아오는 FutureBuilder
                  //                           FutureBuilder<String>(
                  //                             future: _topicName(
                  //                                 chatRoomList[index]
                  //                                     .topicId),
                  //                             builder: (context,
                  //                                 topicSnapshot) {
                  //                               if (topicSnapshot
                  //                                       .connectionState ==
                  //                                   ConnectionState
                  //                                       .waiting) {
                  //                                 return const Text(
                  //                                     '주제: 불러오는 중...');
                  //                               } else if (topicSnapshot
                  //                                   .hasError) {
                  //                                 return Text(
                  //                                     '주제: 오류 발생 - ${topicSnapshot.error}');
                  //                               } else if (topicSnapshot
                  //                                   .hasData) {
                  //                                 return Text(
                  //                                     '주제: ${topicSnapshot.data}');
                  //                               } else {
                  //                                 return const Text(
                  //                                     '주제: 데이터 없음');
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       Row(
                  //                         children: [
                  //                           Text(
                  //                               '방이름: ${chatRoomList[index].name}'),
                  //                         ],
                  //                       ),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.end,
                  //                         children: [
                  //                           Container(
                  //                             width: 70,
                  //                             height: 30,
                  //                             decoration: BoxDecoration(
                  //                               border: Border.all(
                  //                                   color: Colors
                  //                                       .grey.shade300),
                  //                             ),
                  //                             child: const Center(
                  //                                 child: Text('예약')),
                  //                           )
                  //                         ],
                  //                       ),
                  //                       Row(
                  //                         children: [
                  //                           Text(
                  //                               '시작: ${chatRoomList[index].startDate}'),
                  //                         ],
                  //                       ),
                  //                       Row(
                  //                         children: [
                  //                           Text(
                  //                               '종료: ${chatRoomList[index].endDate}'),
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),
                  Consumer<ChatRoomProvider>(
                    builder: (context, chatRoomProvider, child) {
                      final chatRoomList = chatRoomProvider.chatRooms;
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: chatRoomList.length,
                              itemBuilder: (context, index) {
                                isReserveDisable = _reserveButtonDisable(
                                    chatRoomList[index].startDate);
                                isParticipateDisable =
                                    _participateButtonDisable(
                                        chatRoomList[index].endDate);
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _onChatRoomDetailTap(
                                          chatRoomList[index]),
                                      child: ListTile(
                                        title: Container(
                                          height: 180,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // 주제를 비동기적으로 받아오는 FutureBuilder
                                                    FutureBuilder<String>(
                                                      future: _topicName(
                                                          chatRoomList[index]
                                                              .topicId),
                                                      builder: (context,
                                                          topicSnapshot) {
                                                        if (topicSnapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                              '주제: 불러오는 중...');
                                                        } else if (topicSnapshot
                                                            .hasError) {
                                                          return Text(
                                                              '주제: 오류 발생 - ${topicSnapshot.error}');
                                                        } else if (topicSnapshot
                                                            .hasData) {
                                                          return Text(
                                                              '주제: ${topicSnapshot.data}');
                                                        } else {
                                                          return const Text(
                                                              '주제: 데이터 없음');
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '방이름: ${chatRoomList[index].name}'),
                                                  ],
                                                ),
                                                const SizedBox(height: 40),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '시작: ${chatRoomList[index].startDate}'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '종료: ${chatRoomList[index].endDate}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 70,
                                      right: 35,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: isParticipateDisable
                                                ? _onParticipateChatTap
                                                : null,
                                            child:
                                                const Center(child: Text('참여')),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed:
                                                isReserveDisable ? () {} : null,
                                            child:
                                                const Center(child: Text('예약')),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: _onCreateChatRoomTap,
                      icon: const FaIcon(
                        FontAwesomeIcons.circlePlus,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
