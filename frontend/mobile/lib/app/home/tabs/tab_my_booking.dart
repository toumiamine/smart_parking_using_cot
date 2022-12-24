import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/Models/ReservationRequestModel.dart';
import 'package:flutter_parking_ui_new/app/booking/parking_time_screen.dart';
import 'package:flutter_parking_ui_new/app/data/data_file.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/APIServices.dart';
import '../../../base/color_data.dart';
import '../../../base/actions.dart' as slideAction;
import '../../../base/pref_data.dart';
import '../../../base/widget_utils.dart';
import '../../booking/parking_ticket_screen.dart';
import '../../model/model_my_booking.dart';
import '../../routes/app_routes.dart';
import 'package:empty_widget/empty_widget.dart';


class TabMyBooking extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabMyBooking();
  }
}

class _TabMyBooking extends State<TabMyBooking> {
  List<ModelMyBooking> bookingList = [];
  List<ModelMyBooking> bookingHistoryList = [];

  Future _fetch() async {
    final moonLanding = DateTime.parse('2022-01-22 20:18:04');
    final hh = DateTime.parse('2022-01-26 20:18:04');
    print(hh.difference(moonLanding).runtimeType);
    bookingList = [];
    bookingHistoryList = [];
    SharedPreferences prefs = await PrefData.getPrefInstance();
    String? email = prefs.getString(PrefData.email);
   // print(email);
    await APIService.GetUserReservation(email!).then((value) => {
  for (ReservationRequestModel reservation in value) {
if (DateTime.now().millisecondsSinceEpoch <int.parse(reservation.end_date!) ) {
  bookingList.add(ModelMyBooking("imgDetail.png", reservation.id!, "Parking Technopark El Ghazala", "Elgazala Technopark, 2088, Ariana", "Parking Ongoing", int.parse(reservation.start_date!),reservation.start_date!,reservation.end_date!,reservation.selectedSpot!))
}
else {
  bookingHistoryList.add(ModelMyBooking("imgDetail.png", reservation.id!, "Parking Technopark El Ghazala", "Elgazala Technopark, 2088, Ariana", "Parking Ongoing", int.parse(reservation.start_date!),reservation.start_date!,reservation.end_date!,reservation.selectedSpot!))

}

      }

    }
    );
  }
  int selectedIndex = 0;
  List<String> orderTabList = ["Ongoing", "History"];

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
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  getToolbarWidget(context, "My Booking", () {}),
                  getVerSpace(30.h),
                  getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 10.w),
                      Row(
                        children: List.generate(orderTabList.length, (index) {
                          return Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                width: double.infinity,
                                height: 40.h,
                                decoration: getButtonDecoration(
                                  (selectedIndex == index)
                                      ? getAccentColor(context)
                                      : Colors.transparent,
                                  withCorners: true,
                                  corner: 20.h,
                                  withBorder: (selectedIndex != index),
                                  borderColor: (getFontColor(context)),
                                ),
                                child: Center(
                                    child: getCustomFont(
                                        orderTabList[index],
                                        16,
                                        (selectedIndex == index)
                                            ? Colors.black
                                            : getFontColor(context),
                                        1,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center)),
                              ),
                            ),
                            flex: 1,
                          );
                        }),
                      )),
                  Expanded(
                    child: (selectedIndex == 0) && (bookingList.length>0)
                        ? ListView.builder(
                      itemBuilder: (context, index) {
                        ModelMyBooking modelBooking = bookingList[index];
                        return Slidable(
                          child: buildBookingItemContainer(
                              horSpace,
                              context,
                              Column(
                                children: [
                                  buildBookingItem(context, modelBooking, false),
                                  getVerSpace(15.h),
                                  Divider(
                                    height: 2.h,
                                    color: dividerColor,
                                  ),
                                  getVerSpace(12.h),
                                  Row(
                                    children: [
                                      getCustomFont("Time Remaining = ", 16,
                                          getFontGreyColor(context), 1,
                                          fontWeight: FontWeight.w600),
                                      Expanded(
                                        child: getCustomFont(
                                            "${DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now()).inDays} Day(s), ${DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now().add(Duration(days:DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now()).inDays))).inHours} Hour(s), ${DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now().add(Duration(days:DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now()).inDays,hours:DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now().add(Duration(days:DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.now()).inDays))).inHours))).inMinutes} Minute(s)",
                                            16,
                                            getFontColor(context),
                                            1,
                                            fontWeight: FontWeight.w600),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  getVerSpace(20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: getSubButton(
                                            context,
                                            getAccentColor(context),
                                            true,
                                            "View Time",
                                            Colors.black, () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => new ParkingTimeScreen(start_date: modelBooking.start_date!, end_date: modelBooking.end_date!, selected_spot: modelBooking.selected_spot),
                                              ));
                                        }, EdgeInsets.zero),
                                        flex: 1,
                                      ),
                                      getHorSpace(12.w),
                                      Expanded(
                                        child: getSubButton(
                                            context,
                                            Colors.transparent,
                                            true,
                                            "View Ticket",
                                            getFontColor(context),
                                            isBorder: true, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => new ParkingTicketScreen(code: modelBooking.bookingId, selected_date: DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).toString().substring(0,10) , selected_time: DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).toString().substring(11), number_hours: DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.end_date!))).inHours, selected_spot: modelBooking.selected_spot, selected_payement: 2,),
                                          ));

                                        }, EdgeInsets.zero,
                                            borderColor: getFontColor(context)),
                                        flex: 1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                                  () {}),
                          endActionPane: ActionPane(
                            extentRatio: 0.28,
                            motion: ScrollMotion(),
                            children: [
                              slideAction.SlidableAction(
                                margin: EdgeInsets.only(
                                    bottom: 10.h, right: horSpace, top: 10.h),
                                // padding: EdgeInsets.symmetric(vertical: 10.h) ,
                                // An action can be bigger than the others.
                                flex: 1,
                                borderRadius: BorderRadius.circular(12.h),
                                onPressed: (context) {
                                  Get.bottomSheet(
                                      SizedBox.fromSize(
                                        size: Size(double.infinity, 325.h),
                                        child: getPaddingWidget(
                                            edgeInsets,
                                            Column(
                                              children: [
                                                getVerSpace(10.h),
                                                SizedBox(
                                                  width: 40.w,
                                                  child: Divider(
                                                    color:
                                                    getFontGreyColor(context),
                                                    thickness: 4.h,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: getVerSpace(0),
                                                  flex: 1,
                                                ),
                                                getCustomFont(
                                                  "Cancel Parking",
                                                  22,
                                                  getFontColor(context),
                                                  1,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                getVerSpace(20.h),
                                                Divider(
                                                  thickness: 2.h,
                                                  color: dividerColor,
                                                ),
                                                getVerSpace(20.h),
                                                getMultilineCustomFont(
                                                  "Are you sure you want to cancel your reservation? ",
                                                  16,
                                                  getFontColor(context),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                getVerSpace(8.h),
                                                getMultilineCustomFont(
                                                    "Only 90% of the money you can refund from your payment\naccording to our policy",
                                                    12,
                                                    getFontGreyColor(context),
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.center),
                                                getVerSpace(20.h),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: getSubButton(
                                                          context,
                                                          Colors.transparent,
                                                          true,
                                                          "Cancel",
                                                          getFontColor(context),
                                                              () {
                                                            Get.back();
                                                          }, EdgeInsets.zero,
                                                          isBorder: true,
                                                          borderColor:
                                                          getFontColor(
                                                              context)),
                                                      flex: 1,
                                                    ),
                                                    getHorSpace(20.w),
                                                    Expanded(
                                                      child: getSubButton(
                                                        context,
                                                        getAccentColor(context),
                                                        true,
                                                        "Yes,Remove",
                                                        getFontColor(context),
                                                            () {
                                                          Get.back();
                                                        },
                                                        EdgeInsets.zero,
                                                        isBorder: false,
                                                      ),
                                                      flex: 1,
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: getVerSpace(0),
                                                  flex: 1,
                                                )
                                              ],
                                            )),
                                      ),
                                      // elevation: 20.0,
                                      // enableDrag: false,
                                      backgroundColor: getCardColor(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(32.h)),
                                        //     borderRadius: BorderRadius.only(
                                        //   topLeft: Radius.circular(30.0),
                                        //   topRight: Radius.circular(30.0),
                                        // )
                                      ));
                                },
                                backgroundColor: redBgColor,
                                foregroundColor: redColor,
                                icon: getSvgImageWithSize(
                                    context, "trash.svg", 24.h, 24.h),
                              ),
                            ],
                          ),
                        );
                      },
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      itemCount: bookingList.length,
                    ) :
                      (selectedIndex == 0) && (bookingList.length==0) ?
                      EmptyWidget(
                        image: "assets/images/empty.png",
                      //  packageImage: PackageImage.Image_1,
                        title: 'No reservations',
                        subTitle: 'No  reservation available yet',
                        titleTextStyle: TextStyle(
                          fontSize: 22,
                          color: Color(0xff9da9c7),
                          fontWeight: FontWeight.w500,
                        ),
                        subtitleTextStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xffabb8d6),
                        ),
                      ) :
                      (selectedIndex == 1) && (bookingHistoryList.length>0) ?
                      ListView.builder(
                        itemBuilder: (context, index) {
                          ModelMyBooking modelBooking = bookingHistoryList[index];
                          return buildBookingItemContainer(
                              horSpace,
                              context,
                              buildBookingItem(
                                context,
                                modelBooking,
                                true,
                              ), () {
                            Constant.sendToNext(
                                context, Routes.bookingDetailScreen);
                          });
                        },
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemCount: bookingHistoryList.length,
                      )
                        : EmptyWidget(
                        image: "assets/images/empty.png",
                        //  packageImage: PackageImage.Image_1,
                        title: 'No reservations',
                        subTitle: 'No  reservation available yet',
                        titleTextStyle: TextStyle(
                          fontSize: 22,
                          color: Color(0xff9da9c7),
                          fontWeight: FontWeight.w500,
                        ),
                        subtitleTextStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xffabb8d6),
                        ),
                      ) ,
                    flex: 1,
                  )
                  // Expanded(
                  //   child: ListVi,
                  //   flex: 1,
                  // )
                ],
              ),
            );
          }
        }
    );

  }

  Container buildBookingItemContainer(
      double horSpace, BuildContext context, Widget child, Function function) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horSpace, vertical: 20.h),
      decoration: getButtonDecoration(getCardColor(context),
          withCorners: true,
          corner: 12.h,
          shadow: [
            BoxShadow(
                color: Color.fromRGBO(61, 61, 61, 0.11999999731779099),
                offset: Offset(-4, 8),
                blurRadius: 25)
          ]),
      margin: EdgeInsets.symmetric(horizontal: horSpace, vertical: 10.h),
      child: InkWell(
          onTap: () {
            function();
          },
          child: child),
    );
  }

  Widget buildBookingItem(
      BuildContext context, ModelMyBooking modelBooking, bool isHistory) {
    Color setColor = (isHistory) ? greenColor : orangeColor;
    return Row(
      children: [
        Stack(
          children: [
            getCircularImage(context, 131.h, 130.h, 23.h, modelBooking.img,
                boxFit: BoxFit.cover),
            Container(
              width: 30.h,
              height: 30.h,
              margin: EdgeInsets.only(left: 21.h),
              decoration: BoxDecoration(
                  color: getAccentColor(context),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(6.h),
                  )),
              child: Center(
                child: getCustomFont("${DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.start_date!)).difference(DateTime.fromMillisecondsSinceEpoch( int.parse(modelBooking.end_date!))).inHours.toString()} hr", 12,
                    getFontColor(context), 1,
                    fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              ),
            )
          ],
        ),
        getHorSpace(16.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("Booking ID: ${modelBooking.bookingId}", 14,
                  getFontColor(context), 1,
                  fontWeight: FontWeight.w500),
              getVerSpace(7.h),
              getCustomFont(modelBooking.title, 14, getFontColor(context), 1,
                  fontWeight: FontWeight.w400),
              getVerSpace(7.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getSvgImageWithSize(context, "location.svg", 16.h, 16.h),
                  getHorSpace(7.w),
                  Expanded(
                    child: getCustomFont(
                        modelBooking.address, 12, getFontGreyColor(context), 1,
                        fontWeight: FontWeight.w500),
                    flex: 1,
                  )
                ],
              ),
              getVerSpace(13.h),
              Container(
                decoration: getButtonDecoration(setColor.withOpacity(0.11),
                    withCorners: true, corner: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: getCustomFont(modelBooking.title, 12, setColor, 1,
                    fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              )
            ],
          ),
          flex: 1,
        )
      ],
    );
  }
}
