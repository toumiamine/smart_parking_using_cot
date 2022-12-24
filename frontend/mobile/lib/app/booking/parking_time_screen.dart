import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../routes/app_routes.dart';

class ParkingTimeScreen extends StatefulWidget {
  final String start_date;
  final String end_date;
  final String selected_spot;
  ParkingTimeScreen ({ Key? key, required this.end_date, required this.start_date, required this.selected_spot,}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParkingTimeScreen();
  }
}

class _ParkingTimeScreen extends State<ParkingTimeScreen> {
  finish() {
    Constant.backToFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getToolbarWidget(context, "Parking time", () {}),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30.h),
                          width: 314.w,
                          height: 174.w,
                          decoration: getButtonDecoration(yellowBgColor,
                              withCorners: true,
                              corner: 16.w,
                              shadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        61, 61, 61, 0.11999999731779099),
                                    offset: Offset(-4, 8),
                                    blurRadius: 25)
                              ]),
                          padding: EdgeInsets.all(20.w),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: getButtonDecoration(
                              getCardColor(context),
                              withCorners: true,
                              corner: 16.w,
                            ),
                            child: Center(
                              child: getCustomFont(
                                  "${DateTime.fromMillisecondsSinceEpoch( int.parse(widget.end_date)).toString().substring(11,16)}", 60, getFontColor(context), 1,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.digitalFontsFamily),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          children: [
                            buildRowItem(context, "Parking Area", "Technopark Ghazella"),
                            buildRowItem(
                                context, "Address", "Route de Raoued Km. 3,5 La Gazelle 2083"),
                            buildRowItem(
                                context, "Parking Spot", "Ground Floor(${widget.selected_spot})"),
                            buildRowItem(context, "Date", DateTime.fromMillisecondsSinceEpoch( int.parse(widget.start_date)).toString().substring(0,10)),
                            buildRowItem(context, "Duration", "${DateTime.fromMillisecondsSinceEpoch( int.parse(widget.start_date!)).difference(DateTime.fromMillisecondsSinceEpoch( int.parse(widget.end_date!))).inHours.toString()} Hour(s)"),
                            buildRowItem(context, "Hours", "${DateTime.fromMillisecondsSinceEpoch( int.parse(widget.end_date)).toString().substring(11,19)} -${DateTime.fromMillisecondsSinceEpoch( int.parse(widget.start_date)).toString().substring(11,19)}"),
                          ],
                        ),
                      )
                    ],
                  ),
                  flex: 1),
              getVerSpace(25.h),
              getButtonFigma(context, getAccentColor(context), true,
                  "Extend Parking Time", Colors.black, () {
                Constant.sendToNext(context, Routes.extendTimeScreen);
              }, edgeInsets),
              getVerSpace(25.h)
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  Widget buildRowItem(BuildContext context, String title1, String title2) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 9.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: getCustomFont(title1, 16, getFontGreyColor(context), 1,
                fontWeight: FontWeight.w500),
            flex: 1,
          ),
          getCustomFont(title2, 16, getFontColor(context), 1,
              fontWeight: FontWeight.w500)
        ],
      ),
    );
  }

  Widget buildListWidget(BuildContext context, String title, String desc,
      String title2, String desc2) {
    return getPaddingWidget(
        EdgeInsets.symmetric(vertical: 10.h),
        Row(
          children: [
            buildDetailItem(context, title, desc),
            buildDetailItem(context, title2, desc2),
          ],
        ));
  }

  Expanded buildDetailItem(
      BuildContext context, String title, String subtitle) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont(title, 16, getFontGreyColor(context), 1,
              fontWeight: FontWeight.w500),
          getVerSpace(6.h),
          getCustomFont(subtitle, 16, getFontColor(context), 1,
              fontWeight: FontWeight.w500)
        ],
      ),
      flex: 1,
    );
  }
}
