import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todomate/chat/chat_inner_screen/chat_inner_screen.dart';
import 'package:todomate/chat/chats_screen/models/chat_model.dart';
import 'package:todomate/chat/core/app_export.dart';

class ChatsItemWidget extends StatelessWidget {
  final ChatModel item;
  const ChatsItemWidget(this.item, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ChatInnerScreen())),
      child: Container(
        margin: EdgeInsets.only(
          top: getVerticalSize(6.0),
          bottom: getVerticalSize(6.0),
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: ColorConstant.whiteA700,
          borderRadius: BorderRadius.circular(
            getHorizontalSize(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  item.image,
                  height: getSize(64),
                  width: getSize(64),
                  fit: BoxFit.fill,
                ),
                const Gap(8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.gray900,
                                fontSize: getFontSize(16),
                                fontFamily: 'General Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(2),
                      Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.gray900,
                          fontSize: getFontSize(14),
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        item.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.bluegray400,
                          fontSize: getFontSize(14),
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.getFormattedDate(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorConstant.bluegray400,
                        fontSize: getFontSize(14),
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(17),
                    if (item.unread > 0)
                      Container(
                        alignment: Alignment.center,
                        height: getSize(20),
                        width: getSize(20),
                        decoration: BoxDecoration(
                          color: const Color(0xffFF642D),
                          borderRadius:
                              BorderRadius.circular(getHorizontalSize(22)),
                        ),
                        child: Text(
                          item.unread.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstant.whiteA700,
                            fontSize: getFontSize(12),
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
