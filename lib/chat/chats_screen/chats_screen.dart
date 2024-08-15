import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:todomate/chat/core/app_export.dart';
import 'package:todomate/chat/core/scroll_controller_mixin.dart';

import 'models/chat_model.dart';
import 'widgets/chats_item_widget.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with ScrollControllerMixin {
  List<ChatModel> chatList = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  void loadChats() {
    setState(() {
      chatList = itemsList.map((item) => ChatModel.fromJson(item)).toList();
      chatList.sort((a, b) => b.date.compareTo(a.date)); // 날짜 기준으로 내림차순 정렬
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTop());
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorConstant.fromHex('#FF642D'),
              ColorConstant.fromHex('#FF642D'),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: getVerticalSize(71),
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "채팅",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.whiteA700,
                      fontSize: getFontSize(34),
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SvgPicture.asset(
                  //   ImageConstant.imgFrame242,
                  //   fit: BoxFit.fill,
                  // ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatsItemWidget(chatList[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          height: getVerticalSize(83),
          width: MediaQuery.of(context).size.width,
          color: ColorConstant.whiteA700E5,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: getVerticalSize(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ImageConstant.imgIcon1,
                  ImageConstant.imgIcon,
                  ImageConstant.imgIcon3,
                ]
                    .map<Widget>((icon) => SizedBox(
                          height: getSize(26),
                          width: getSize(24),
                          child: SvgPicture.asset(
                            icon,
                            fit: BoxFit.fill,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
