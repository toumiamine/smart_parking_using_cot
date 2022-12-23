import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/data/data_file.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/model_chat.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatScreen();
  }
}

class _ChatScreen extends State<ChatScreen> {
  finish() {
    Constant.backToPrev(context);
  }

  List<ModelChat> chattingList = DataFile.getChattingList();

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
          appBar: getInVisibleAppBar(),
          body: getPaddingWidget(
              edgeInsets,
              Column(children: [
                getVerSpace(10.h),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  child: Row(
                    children: [
                      getBackIcon(context, () {}),
                      getHorSpace(20.w),
                      getCircleImage(context, "profile.png", 55.h),
                      getHorSpace(20.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                                "Jane Cooper", 22, getFontColor(context), 1,
                                fontWeight: FontWeight.w600),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: greenColor,
                                  size: 12.h,
                                ),
                                getHorSpace(6.w),
                                Expanded(
                                  child: getCustomFont("Online", 14,
                                      getFontGreyColor(context), 1,
                                      fontWeight: FontWeight.w500),
                                  flex: 1,
                                )
                              ],
                            )
                          ],
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        ModelChat modelChat = chattingList[index];
                        Radius radius = Radius.circular(15.h);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: (modelChat.isSender)
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            getVerSpace(30.h),
                            Container(
                              width: 250.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                  color: (modelChat.isSender)
                                      ? "#FFF2D3".toColor()
                                      : getGreyCardColor(context),
                                  borderRadius: BorderRadius.only(
                                      topLeft: radius,
                                      topRight: radius,
                                      bottomRight: (!modelChat.isSender)
                                          ? radius
                                          : Radius.zero,
                                      bottomLeft: (modelChat.isSender)
                                          ? radius
                                          : Radius.zero),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(
                                            0, 0, 0, 0.10000000149011612),
                                        offset: Offset(0, 2),
                                        blurRadius: 2)
                                  ]),
                              child: getMultilineCustomFont(
                                  modelChat.msg, 14, getFontColor(context),
                                  fontWeight: FontWeight.w400),
                            ),
                            getVerSpace(6.h),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: (modelChat.isSender)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                getPaddingWidget(
                                    EdgeInsets.only(left: 16.w),
                                    getCustomFont(modelChat.time, 12,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500)),
                                (modelChat.isSender)
                                    ? getSvgImageWithSize(
                                        context, "done_all.svg", 16.h, 16.h,
                                        fit: BoxFit.fill)
                                    : getVerSpace(0)
                              ],
                            )
                          ],
                        );
                      },
                      itemCount: chattingList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          // left: horSpace,
                          // right: horSpace,
                          top: 10.h,
                          bottom: 20.h)),
                  flex: 1,
                ),
                Container(
                  height: 48.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: buildWidgetBorder(Container(
                          padding: edgeInsets,
                          height: double.infinity,
                          child: Center(
                            child: TextField(
                              style: buildTextStyle(context,
                                  getFontColor(context), FontWeight.w400, 14),
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Your message",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: buildTextStyle(
                                      context,
                                      getFontGreyColor(context),
                                      FontWeight.w400,
                                      14)),
                            ),
                          ),
                        )),
                        flex: 1,
                      ),
                      getHorSpace(15.w),
                      buildWidgetBorder(Container(
                        width: 48.h,
                        height: double.infinity,
                        child: Center(
                            child: getSvgImageWithSize(
                                context, "send.svg", 24.h, 24.h,
                                fit: BoxFit.scaleDown)),
                      ))
                    ],
                  ),
                ),
                getVerSpace(30.h)
              ])),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  Container buildWidgetBorder(Widget widget) {
    return Container(
      decoration: getButtonDecoration(Colors.transparent,
          withCorners: true,
          corner: 15.h,
          withBorder: true,
          borderColor: dividerColor),
      child: widget,
    );
  }
}
