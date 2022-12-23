import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../routes/app_routes.dart';

class ParkingTicketScreen extends StatefulWidget {
  final String selected_date;
  final String selected_time;
  final String code;
  final int number_hours;
  final int selected_payement;
  final String selected_spot;
  ParkingTicketScreen ({ Key? key, required this.code , required this.selected_date  , required this.selected_time , required this.number_hours, required this.selected_spot, required this.selected_payement }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParkingTicketScreen();
  }
}

class _ParkingTicketScreen extends State<ParkingTicketScreen> {
  finish() {
    Constant.sendToNext(context, Routes.homeScreenRoute);
  }
  String name='';
  String phonenum='';
  Future _fetch() async {
    SharedPreferences prefs = await PrefData.getPrefInstance();
    name = prefs.getString(PrefData.fullname)!;
    phonenum = prefs.getString(PrefData.phonenumber)!;
  }
  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);
    return FutureBuilder(future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
                backgroundColor: Colors.blue);
          }
          else {
            return WillPopScope(
                child: Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getToolbarWidget(context, "Parking ticket", () {}),
                      Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: horSpace, vertical: 20.h),
                            margin: EdgeInsets.symmetric(
                                horizontal: horSpace, vertical: 30.h),
                            decoration: getButtonDecoration(getCardColor(context),
                                corner: 18.h,
                                shadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(
                                          61, 61, 61, 0.11999999731779099),
                                      offset: Offset(-4, 8),
                                      blurRadius: 25)
                                ]),
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: horSpace, vertical: 20.h),
                              primary: true,
                              children: [
                                getMultilineCustomFont(
                                  "Scan this on the scanner machine when you are in the parking",
                                  16,
                                  getFontGreyColor(context),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                ),
                                Center(
                                  child: Container(
                                    width: 210.h,
                                    height: 210.h,
                                    margin: EdgeInsets.symmetric(vertical: 20.h),
                                    decoration: getButtonDecoration(
                                        getCardColor(context),
                                        withCorners: true,
                                        corner: 18.h,
                                        shadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  61, 61, 61, 0.11999999731779099),
                                              offset: Offset(-4, 8),
                                              blurRadius: 25)
                                        ]),
                                    child: Center(
                                      child: QrImage(
                                        data: widget.code,
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                                buildListWidget(context, "Name", name,
                                    "Phone", "00216 " + phonenum),
                                buildListWidget(context, "Parking", "Technopark Ghazella", "Parking Slot","Ground Floor"+ "("+widget.selected_spot+")"),
                                buildListWidget(context, "Date", widget.selected_date,  "Duration", widget.number_hours.toString()+" Hour(s)"),
                                buildListWidget(context, "Start Hour", widget.selected_time,
                                    "End Hour",(int.parse(widget.selected_time.substring(0,2)).toInt()+widget.number_hours).toString()+widget.selected_time.substring(2) )
                              ],
                            ),
                          ),
                          flex: 1),
                      getButtonFigma(context, getAccentColor(context), true,
                          "Get Direction", Colors.black, () {}, edgeInsets),
                      getVerSpace(15.h),
                      getButtonFigma(
                        context,
                        Colors.transparent,
                        true,
                        "Home screen",
                        getFontColor(context),
                            () {
                          Constant.sendToNext(context, Routes.homeScreenRoute);
                        },
                        edgeInsets,
                        isBorder: true,
                        borderColor: getFontColor(context),
                      ),
                      getVerSpace(30.h),
                    ],
                  ),
                ),
                onWillPop: () async {
                  finish();
                  return false;
                });
          }
        }
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
