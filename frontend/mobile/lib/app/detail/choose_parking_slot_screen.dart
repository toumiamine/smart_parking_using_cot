import 'dart:convert';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../data/data_file.dart';
import '../model/model_slot_detail.dart';
import '../payment/choose_payment_method_screen.dart';

class ChooseParkingSlotScreen extends StatefulWidget {

  final String selected_date;
  final String selected_time;
  final int number_hours;
  ChooseParkingSlotScreen ({ Key? key, required this.selected_date  , required this.selected_time , required this.number_hours }): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ChooseParkingSlotScreen();
  }
}

class _ChooseParkingSlotScreen extends State<ChooseParkingSlotScreen> {
  List<String> getFloorList = DataFile.getAllFloorList();
 var channel_availability = WebSocketChannel.connect(Uri.parse('wss://api.smart-parking.me:8443/microprofile/websocket_channel'));
  finish() {
    Constant.backToFinish(context);
  }

  int selectedPos = 0;
  List<ModelSlotDetail> slotList1 = DataFile.getAllSlotList();
  List<ModelSlotDetail> slotList2 = DataFile.getAllSlotSecList();
  String selected_spot = "X";

  void UnselectSlot(List<ModelSlotDetail> L) {
    for(var i=0;i<L.length;i++){
      if (L[i].availability == DataFile.slotUnAvailable) {
        L[i].availability = DataFile.slotAvailable;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);
    return StreamBuilder(
      stream: channel_availability.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> ReceivedConnectedObject = jsonDecode(snapshot.data.toString());
          try {
            String type = ReceivedConnectedObject["type"];
            if (type == "IRSENSOR") {
              String Id = ReceivedConnectedObject["id"];
              int value = ReceivedConnectedObject["value"];
              int n = int.parse(Id[2]);
              if (value==1) {
                slotList1[n-1] = ModelSlotDetail("G0"+Id[2] , DataFile.slotAvailable);
              }
              else {
                slotList1[n-1] = ModelSlotDetail("G0"+Id[2] , DataFile.slotSelected);
              }
            }

          }
          catch (e) {
            print(e);
          }

          //  print(snapshot.data);
          return WillPopScope(
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getToolbarWidget(context, "Choose Parking Slot", () {}),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          padding: EdgeInsets.zero,
                          children: [
                            getVerSpace(20.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  FetchPixels.getDefaultHorSpaceFigma(context)),
                              height: 40.h,
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPos = index;
                                        });
                                      },
                                      child: Container(
                                        height: double.infinity,
                                        margin: EdgeInsets.only(
                                            left: (index != 0) ? 20.w : 0,
                                            right: (index != getFloorList.length - 1)
                                                ? 20.w
                                                : 0),
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                        decoration: getButtonDecoration(
                                            ((selectedPos != index))
                                                ? Colors.transparent
                                                : getAccentColor(context),
                                            withCorners: true,
                                            corner: 20.h,
                                            withBorder: (selectedPos != index),
                                            borderColor: getFontColor(context)),
                                        child: Center(
                                          child: getCustomFont(
                                              getFloorList[index],
                                              14,
                                              (selectedPos == index)
                                                  ? Colors.black
                                                  : getFontColor(context),
                                              1,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: getFloorList.length),
                            ),
                            getVerSpace(12.h),
                            Center(
                              child: getCustomFont(
                                  "Exit", 18, getFontColor(context), 1,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 160.w,
                                  child: ListView.builder(
                                      reverse: true,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        ModelSlotDetail slotDetail = slotList1[index];
                                        bool isLast = (index == 0);
                                        if (slotDetail.availability == 2 ||  slotDetail.availability ==3) {
                                          return Container(
                                            margin: EdgeInsets.only(left: horSpace),
                                            // decoration: DottedDecoration(
                                            //   color: Colors.black,
                                            //   strokeWidth: 0.5,
                                            //   linePosition: LinePosition.left,
                                            // ),
                                            width: 160.h,
                                            height: 60.h,
                                            // height: (isLast) ? 67.h : 60.h,
                                            child:
                                            buildSlotItem(isLast, slotDetail, true),
                                          );
                                        }
                                        else {

                                          return InkWell(
                                            onTap: (){
                                              setState(() {
                                                UnselectSlot(slotList1);
                                                slotDetail.availability = 2;
                                                selected_spot = slotDetail.title;
                                              });

                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: horSpace),
                                              // decoration: DottedDecoration(
                                              //   color: Colors.black,
                                              //   strokeWidth: 0.5,
                                              //   linePosition: LinePosition.left,
                                              // ),
                                              width: 160.h,
                                              height: 60.h,
                                              // height: (isLast) ? 67.h : 60.h,
                                              child:
                                              buildSlotItem(isLast, slotDetail, true),
                                            ),
                                          );
                                        }
                                      },
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: slotList1.length,
                                      shrinkWrap: true),
                                ),
                                Expanded(
                                  child: getVerSpace(0),
                                  flex: 1,
                                ),
                                Container(
                                  width: 160.w,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        ModelSlotDetail slotDetail = slotList2[index];
                                        bool isLast = (index == slotList2.length - 1);
                                        // return Container(
                                        //   height: 50,
                                        //   margin: EdgeInsets.all(5),
                                        //   width: double.infinity,
                                        //   color: Colors.green,
                                        // );
                                        return Container(
                                          margin: EdgeInsets.only(right: horSpace),
                                          // decoration: DottedDecoration(
                                          //   color: Colors.black,
                                          //   strokeWidth: 0.5,
                                          //   linePosition: LinePosition.left,
                                          // ),
                                          width: 160.h,
                                          height: 60.h,
                                          child: buildSlotItem(
                                              isLast, slotDetail, false),
                                        );
                                        // return Container(
                                        //   width: double.infinity,
                                        //   height: 50.h,
                                        //   margin: EdgeInsets.all(7),
                                        //   decoration: DottedDecoration(
                                        //       shape: Shape.box,
                                        //       color: Colors.blue,
                                        //       borderRadius: BorderRadius.only(
                                        //           topLeft: Radius.circular(15)),
                                        //       linePosition: LinePosition.top,
                                        //       strokeWidth: 5),
                                        //   // child: FDottedLine(
                                        //   //   width: double.infinity,
                                        //   //   height: double.infinity,
                                        //   //   color: Colors.green,
                                        //   //
                                        //   //   corner: FDottedLineCorner(
                                        //   //       leftBottomCorner: 0,
                                        //   //       leftTopCorner: 5,
                                        //   //       rightBottomCorner: 0,
                                        //   //       rightTopCorner: 0),
                                        //   //   child: Container(
                                        //   //     width: double.infinity,
                                        //   //     height: double.infinity,
                                        //   //   ),
                                        //   // ),
                                        // );
                                      },
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: slotList2.length,
                                      shrinkWrap: true),
                                )
                              ],
                            ),
                            Center(
                              child: getCustomFont(
                                  "Entry", 18, getFontColor(context), 1,
                                  fontWeight: FontWeight.w500),
                            ),
                            getVerSpace(14.h),
                            getPaddingWidget(
                                edgeInsets,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    getInfoItem(DataFile.slotUnAvailable),
                                    getInfoItem(DataFile.slotAvailable),
                                    getInfoItem(DataFile.slotSelected),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    Container(
                      width: double.infinity,
                      height: 99.h,
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: ShapeDecoration(
                          color: getCardColor(context),
                          shadows: [
                            BoxShadow(
                              // color: Colors.green,
                                color: Color.fromRGBO(0, 0, 0, 0.05000000074505806),
                                offset: Offset(0, -4),
                                blurRadius: 17)
                          ],
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.vertical(
                                  top: SmoothRadius(
                                      cornerRadius: 21.h, cornerSmoothing: 0.5)))),
                      padding: edgeInsets,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    getCustomFont(
                                      "Selected Date = ",
                                      14,
                                      getFontColor(context),
                                      1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Expanded(
                                      child: getCustomFont(
                                        DateFormat('EEEE').format(DateFormat("yyyy-MM-dd").parse(widget.selected_date)) + ', ' + widget.selected_date.toString(),
                                        16,
                                        getFontColor(context),
                                        1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    getCustomFont(
                                      "Numbers of hours = ",
                                      14,
                                      getFontColor(context),
                                      1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Expanded(
                                      child: getCustomFont(
                                        widget.number_hours.toString(),
                                        16,
                                        getFontColor(context),
                                        1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    getCustomFont(
                                      "Selected Slot = ",
                                      14,
                                      getFontColor(context),
                                      1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Expanded(
                                      child: getCustomFont(
                                        selected_spot,
                                        16,
                                        getFontColor(context),
                                        1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                getVerSpace(5.h),
                                getCustomFont(
                                  (widget.number_hours*7*1.19).toString()+
                                      " TND TTC",
                                  18,
                                  getFontColor(context),
                                  1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                          InkWell(
                            onTap: () {
                              if (selected_spot!= "X") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChoosePaymentMethodScreen(selected_date: widget.selected_date, selected_time: widget.selected_time, number_hours:widget.number_hours, selected_spot: selected_spot,)),
                                );
                              }
                              else {
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please select a slot", style: TextStyle(color: Colors.white),)
                              , backgroundColor: Colors.red,
                              )
                              );
                              }
                            },
                            child: Container(
                              width: 120.w,
                              height: 40.h,
                              decoration: getButtonDecoration(getAccentColor(context),
                                  withCorners: true, corner: 20.h, withBorder: true),
                              child: Center(
                                child: getCustomFont("Confirm", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onWillPop: () async {
                finish();
                return false;
              });
        }
        else {
          channel_availability.sink.add('{"id" : "G03","isAvailable" : 0}');
          //   channel_entrance.sink.add('{"');
          return Scaffold(
            body: Center(
                child:  Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.greenAccent,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Loading .." ,style: TextStyle(fontSize: 15),)
                    ]
                )
            ),
          );
        }
        return Text(snapshot.hasData ? '${snapshot.data}' : '');
      },
    );

  }

  Widget getInfoItem(int type) {
    String title = (type == DataFile.slotUnAvailable)
        ? "Selected"
        : (type == DataFile.slotAvailable)
            ? "Available"
            : "Unavailable";
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 24.h,
          height: 24.h,
          decoration: buildSlotBoxDecoration(type, true,
              radius1: BorderRadius.circular(4.h)),
        ),
        getHorSpace(10.w),
        getCustomFont(title, 14, getFontColor(context), 1,
            fontWeight: FontWeight.w500, textAlign: TextAlign.start)
      ],
    );
  }

  Stack buildSlotItem(bool isLast, ModelSlotDetail slotDetail, bool isFirst) {
    LinePosition linePosition =
        (isFirst) ? LinePosition.left : LinePosition.right;
    return Stack(
      children: [
        Container(
          decoration: DottedDecoration(
            color: Colors.black,
            strokeWidth: 0.5,
            linePosition: linePosition,
          ),
        ),
        Container(
          decoration: DottedDecoration(
            color: Colors.black,
            strokeWidth: 0.5,
            linePosition: LinePosition.top,
          ),
        ),
        (isLast)
            ? Container(
                decoration: DottedDecoration(
                  color: Colors.black,
                  strokeWidth: 0.5,
                  linePosition: LinePosition.bottom,
                ),
              )
            : getVerSpace(0),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: buildSlotBoxDecoration(slotDetail.availability, isFirst),
          margin: EdgeInsets.only(
              left: (isFirst) ? 12.w : 0,
              right: (!isFirst) ? 12.w : 0,
              top: 7.h,
              bottom: 7.h),
          child: Align(
            alignment: (isFirst) ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
                width: 42.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: darkGreyColor,
                  borderRadius: BorderRadius.horizontal(
                      right: (isFirst) ? Radius.circular(10.h) : Radius.zero,
                      left: (!isFirst) ? Radius.circular(10.h) : Radius.zero),
                ),
                child: Center(
                  child: getCustomFont(
                    slotDetail.title,
                    14,
                    Colors.white,
                    1,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        )
      ],
    );
  }

  BoxDecoration buildSlotBoxDecoration(int type, bool isFirstList,
      {BorderRadius? radius1}) {
    BorderRadius? radius = radius1;
    Radius radiusSet = Radius.circular(10.h);

    if (radius == null) {
      radius = BorderRadius.horizontal(
          left: (!isFirstList) ? radiusSet : Radius.zero,
          right: (isFirstList) ? radiusSet : Radius.zero);
    }
    Color getColors = unAvailableColor;
    bool isBorder = false;
    switch (type) {
      case DataFile.slotUnAvailable:
        getColors = unAvailableColor;
        break;
      case DataFile.slotAvailable:
        getColors = Colors.transparent;
        isBorder = true;
        break;
      case DataFile.slotSelected:
        getColors = slotSelectedColor;
        break;
    }
    return BoxDecoration(
        color: getColors,
        border:
            (isBorder) ? Border.all(color: darkGreyColor, width: 1.h) : null,
        borderRadius: radius);
  }
}
