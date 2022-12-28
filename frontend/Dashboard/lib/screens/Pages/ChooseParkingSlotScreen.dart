import 'dart:convert';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '/../base/widget_utils.dart';
import '/../base/data/data_file.dart';
import '/../base/model/model_slot_detail.dart';

class ChooseParkingSlotScreen extends StatefulWidget {

 late int count=0;
  @override
  State<StatefulWidget> createState() {
    return _ChooseParkingSlotScreen();
  }
}

class _ChooseParkingSlotScreen extends State<ChooseParkingSlotScreen> {
  List<String> getFloorList = DataFile.getAllFloorList();

  late final int count;
  var channel_availability = WebSocketChannel.connect(Uri.parse('wss://api.smart-parking.me:8443/microprofile/websocket_channel'));

  finish() {
    Constant.backToFinish(context);
  }

  int selectedPos = 0;
  List<ModelSlotDetail> slotList1 = DataFile.getAllSlotList();
  List<ModelSlotDetail> slotList2 = DataFile.getAllSlotSecList();

  int leng (int l) {

    l=slotList2.length;


    return l;
  }

  void UnselectSlot(List<ModelSlotDetail> L) {
    for(var i=0;i<L.length;i++){
      if (L[i].availability == DataFile.slotSelected) {
        L[i].availability = DataFile.slotAvailable;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
   //Constant.setupSize(context);
    ScreenUtil.init(context,
        designSize: Size(920, 920), minTextAdapt: true);
    double horSpace = 20.w;
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

      return WillPopScope(
          child: Scaffold(
            backgroundColor:  darkGreyColor.withOpacity(0.15),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getToolbarWidget(context, "Check Parking Slots Availability", () {}),
                Expanded(
                  // child: Container(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    // child: Container(),
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
                              20.w),
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
                                            : darkGreyColor.withOpacity(0.5),
                                        withCorners: true,
                                        corner: 20.h,
                                        withBorder: (selectedPos != index),
                                        borderColor: Colors.white),
                                    child: Center(
                                      child: getCustomFont(
                                          getFloorList[index],
                                          14,
                                          (selectedPos == index)
                                              ? Colors.white
                                              : Colors.white,
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
                              "Exit", 18, Colors.white, 1,
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
                                    if (slotDetail.availability == 2) {
                                      return Container(
                                        margin: EdgeInsets.only(left: horSpace),
                                        width: 160.h,
                                        height: 60.h,
                                        child:
                                        buildSlotItem(isLast, slotDetail, true),
                                      );
                                    }
                                    else {
                                      return Container(
                                          margin: EdgeInsets.only(left: horSpace),
                                          width: 120.h,
                                          height: 60.h,
                                          child:
                                          buildSlotItem(isLast, slotDetail, true),
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
                                    return Container(
                                      margin: EdgeInsets.only(right: horSpace),
                                      width: 160.h,
                                      height: 60.h,
                                      child: buildSlotItem(
                                          isLast, slotDetail, false),
                                    );

                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: slotList2.length,
                                  shrinkWrap: true),
                            )
                          ],
                        ),
                        Center(
                          child: getCustomFont(
                              "Entry", 18, Colors.white, 1,
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
                              ],
                            ))
                      ],
                    ),
                  ),
                  flex: 1,
                ),
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
      return Center(
        child: Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            Center(child: new Text("Fetching data..."))
          ],
        ),
      );
    }
    return Text(snapshot.hasData ? '${snapshot.data}' : '');
  },
);

  }

  Widget getInfoItem(int type) {
    String title = (type == DataFile.slotUnAvailable)
        ? "Unavailable"
        : (type == DataFile.slotAvailable)
        ? "Available"
        : "Available";
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
        getCustomFont(title, 14, Colors.white, 1,
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
            color: Colors.white,
            strokeWidth: 0.5,
            linePosition: linePosition,
          ),
        ),
        Container(
          decoration: DottedDecoration(
            color: Colors.white,
            strokeWidth: 0.5,
            linePosition: LinePosition.top,
          ),
        ),
        (isLast)
            ? Container(
          decoration: DottedDecoration(
            color: Colors.white,
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
        getColors = darkGreyColor;
        break;
      case DataFile.slotAvailable:
        getColors = Colors.white;
        isBorder = true;
        break;
      case DataFile.slotSelected:
        getColors = darkGreyColor;
        break;
    }
    return BoxDecoration(
        color: getColors,
        border:
        (isBorder) ? Border.all(color: darkGreyColor, width: 1.h) : null,
        borderRadius: radius);
  }
}
