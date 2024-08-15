import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todomate/chat/core/app_export.dart';
// import 'package:messenger_app/presentation/details/page.dart';
import 'package:todomate/chat/chat_inner_screen/chat_inner_screen.dart';
import 'package:todomate/chat/chats_screen/models/chat_model.dart';

class ChatsItemWidget extends StatelessWidget {
  final ChatModel item;
  const ChatsItemWidget(this.item, {Key? key}) : super(key: key);
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
            getHorizontalSize(
              12,
            ),
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
                  height: getSize(
                    64,
                  ),
                  width: getSize(
                    64,
                  ),
                  fit: BoxFit.fill,
                ),
                const Gap(8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.gray900,
                            fontSize: getFontSize(
                              16,
                            ),
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: getHorizontalSize(
                              4,
                            ),
                          ),
                          child: SizedBox(
                            height: getSize(
                              16,
                            ),
                            width: getSize(
                              16,
                            ),
                            // child: item.pinned == false && item.muted == false
                            //     ? const SizedBox()
                            //     : SvgPicture.asset(
                            //         item.pinned == true
                            //             ? ImageConstant.imgIconpin
                            //             : ImageConstant.imgIconsoundoff1,
                            //         fit: BoxFit.fill,
                            //       ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: getVerticalSize(
                          2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getHorizontalSize(
                                    10,
                                  ),
                                ),
                                child: Text(
                                  item.name,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.gray900,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'General Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                item.lastMessage,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.bluegray400,
                                  fontSize: getFontSize(
                                    14,
                                  ),
                                  fontFamily: 'General Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      item.date,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorConstant.bluegray400,
                        fontSize: getFontSize(
                          14,
                        ),
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: getVerticalSize(
                          17,
                        ),
                        bottom: getVerticalSize(
                          1,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: getSize(
                          20,
                        ),
                        width: getSize(
                          20,
                        ),
                        decoration: BoxDecoration(
                          color: item.archived == false
                              ? const Color(0xffFF642D)
                              : const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              22,
                            ),
                          ),
                        ),
                        child: Text(
                          item.unread.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: ColorConstant.whiteA700,
                            fontSize: getFontSize(
                              12,
                            ),
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //
          ],
        ),
      ),
    );
  }
}
