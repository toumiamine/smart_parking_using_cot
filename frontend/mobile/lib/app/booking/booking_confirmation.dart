import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/Models/ReservationRequestModel.dart';
import 'package:flutter_parking_ui_new/app/booking/parking_ticket_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Services/APIServices.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../data/data_file.dart';
import '../model/model_payment_list.dart';
import '../routes/app_routes.dart';
import 'package:uuid/uuid.dart';

class BookingConfirmation extends StatefulWidget {
  final String selected_date;
  final String selected_time;
  final int number_hours;
  final int selected_payement;
  final String selected_spot;
  BookingConfirmation ({ Key? key, required this.selected_date  , required this.selected_time , required this.number_hours, required this.selected_spot, required this.selected_payement }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingConfirmation();
  }
}

class _BookingConfirmation extends State<BookingConfirmation> {
  finish() {
    Constant.backToFinish(context);
  }
  List<ModelPaymentList> allPaymentList = DataFile.getAllPaymentList();
  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);
    var uuid = Uuid();

// Generate a v1 (time-based) id
  String id =  uuid.v1(); //
    final result_id = "P"+ id.substring(0,8).trim().toUpperCase();
    return WillPopScope(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getToolbarWidget(context, "Booking Confirmation", () {}),
              Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      getVerSpace(30.h),
                      getPaddingWidget(
                          edgeInsets,
                          getCustomFont(
                            "Parking Name",
                            16,
                            getFontColor(context),
                            1,
                            fontWeight: FontWeight.w600,
                          )),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: horSpace, vertical: 20.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: horSpace, vertical: 10.h),
                        decoration: getButtonDecoration(getCardColor(context),
                            corner: 12.h,
                            shadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      61, 61, 61, 0.11999999731779099),
                                  offset: Offset(-4, 8),
                                  blurRadius: 25)
                            ]),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont("Parking Technopark Gazella", 22,
                                      getFontColor(context), 1,
                                      fontWeight: FontWeight.w600),
                                  getVerSpace(8.h),
                                  Row(
                                    children: [

                                      Image.asset("assets/images/Marker.png" , height: 16.h, width: 16.h),
                                      getHorSpace(7.w),
                                      getCustomFont("Elgazala Technopark, 2088, Ariana",
                                          12, getFontColor(context), 1,
                                          fontWeight: FontWeight.w500)
                                    ],
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Image.asset("assets/images/Marker.png" , height: 32.h, width: 32.h),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 40.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: horSpace, vertical: 10.h),
                        width: double.infinity,
                        decoration:
                            getButtonDecoration(getCardColor(context), shadow: [
                          BoxShadow(
                              color: Color.fromRGBO(
                                  61, 61, 61, 0.11999999731779099),
                              offset: Offset(-4, 8),
                              blurRadius: 25)
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont("Booking ID:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont(result_id, 14,
                                        getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    getCustomFont("Parking Slot:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont("Ground Floor-"+widget.selected_spot, 14,
                                        getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                )
                              ],
                            ),
                            getVerSpace(20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont("Reserverd Date:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont( DateFormat('EEEE').format(DateFormat("yyyy-MM-dd").parse(widget.selected_date)) + ', ' + widget.selected_date.toString(), 14,
                                        getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    getCustomFont("Time:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont(
                                        widget.selected_time, 14, getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                )
                              ],
                            ),
                            getVerSpace(20.h),
                         /*   Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont("Vehicle Details:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont("Toyota (AFD 6397)", 14,
                                        getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    getCustomFont("Vehicle Type:", 14,
                                        getFontGreyColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                    getVerSpace(4.h),
                                    getCustomFont("Luxury Sedan", 14,
                                        getFontColor(context), 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                )
                              ],
                            ),*/
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              width: double.infinity,
                              decoration: DottedDecoration(
                                  linePosition: LinePosition.bottom),
                            ),
                            getCustomFont(
                                "Cost", 14, getFontGreyColor(context), 1,
                                fontWeight: FontWeight.w500),
                            getVerSpace(4.h),
                            Row(
                              children: [
                                Expanded(
                                  child: getCustomFont("Parking hours (${widget.number_hours} hours)",
                                      14, getFontColor(context), 1,
                                      fontWeight: FontWeight.w500),
                                  flex: 1,
                                ),
                                getCustomFont(
                                    (widget.number_hours*7).toString() + " TND", 14, getFontColor(context), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            ),
                            getVerSpace(4.h),
                            Row(
                              children: [
                                Expanded(
                                  child: getCustomFont(
                                      "Tax", 14, getFontColor(context), 1,
                                      fontWeight: FontWeight.w500),
                                  flex: 1,
                                ),
                                getCustomFont(
                                    (widget.number_hours*7*0.19).toString() + " TND", 14, getFontColor(context), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            ),
                            getVerSpace(12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: getCustomFont("Total Amount", 16,
                                      getFontColor(context), 1,
                                      fontWeight: FontWeight.w500),
                                  flex: 1,
                                ),
                                getCustomFont(
                                    (widget.number_hours*7*1.19).toString() + " TND", 16, getFontColor(context), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 20.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: horSpace, vertical: 10.h),
                        width: double.infinity,
                        decoration:
                            getButtonDecoration(getCardColor(context), shadow: [
                          BoxShadow(
                              color: Color.fromRGBO(
                                  61, 61, 61, 0.11999999731779099),
                              offset: Offset(-4, 8),
                              blurRadius: 25)
                        ]),
                        child: Row(
                          children: [
                            getSvgImageWithSize(
                                context, allPaymentList[widget.selected_payement].image, 30.h, 30.h,
                                fit: BoxFit.fill),
                            getHorSpace(20.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(
                                      allPaymentList[widget.selected_payement].title, 20, getFontColor(context), 1,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start),
                                  getVerSpace(4.h),
                                  getCustomFont("xxxx xxxx xxxx 5416", 16,
                                      getFontColor(context), 1,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start)
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  flex: 1),
              getButtonFigma(context, getAccentColor(context), true,
                  "Confirm Payment", Colors.black, () async {

                    Get.defaultDialog(
                        title: "",
                        content: Column(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.greenAccent,
                              ),
                            ),
                            getVerSpace(12.h),
                            getCustomFont(
                                "Loading ..!", 28, getFontColor(context), 1,
                                fontWeight: FontWeight.w700),
                            getVerSpace(12.h),
                            getCustomFont(
                                "Please wait while your transaction is processing.",
                                14,
                                getFontColor(context),
                                2,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                txtHeight: 1.5),

                            getVerSpace(20.h),
                          ],
                        )
                      // content: getAssetImage(context, "check_img.png", 179.h, 155.h,
                      //     boxFit: BoxFit.fill),
                    );
                 String dt =   widget.selected_date+"T"+widget.selected_time;
                 print(dt);
                 DateTime a = DateTime.parse(widget.selected_date+"T"+widget.selected_time);
                 DateTime new_date = a.add(Duration(hours: widget.number_hours));
                    String formattedTime = DateFormat.Hm().format(new_date);
                    String dt_added =   widget.selected_date+"T"+formattedTime;
                    print(dt_added);
              ReservationRequestModel model = ReservationRequestModel(id : result_id, user_id: 'medaminetoumi454@gmail.com', start_date: dt,end_date: dt_added, price: widget.number_hours!*7,selectedSpot: widget.selected_spot);
 await  APIService.CreateReservation(model).then((response) => {
                  if (response== true) {
                    Navigator.pop(context),

                Get.defaultDialog(
                    title: "",
                    content: Column(
                      children: [
                        Image.asset(
                          Constant.assetImagePath + "check_img.png",
                          width: 179.h,
                          height: 155.h,
                        ),
                        getVerSpace(12.h),
                        getCustomFont(
                            "Successful!", 28, getFontColor(context), 1,
                            fontWeight: FontWeight.w700),
                        getCustomFont(
                            "Successfully made payment for your\nparking",
                            14,
                            getFontColor(context),
                            2,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                            txtHeight: 1.5),
                        getVerSpace(20.h),
                        getButtonFigma(context, getAccentColor(context), true,
                            "View Parking Ticket", Colors.black, () {
                             Get.back();
                           Navigator.push(
                               context,
                             MaterialPageRoute(builder: (context) => new ParkingTicketScreen(selected_date: widget.selected_date, selected_time: widget.selected_time, number_hours: widget.number_hours, selected_spot : widget.selected_spot , selected_payement: widget.selected_payement, code : result_id)),
                             );
                            }, EdgeInsets.zero),
                        getVerSpace(20.h),
                      ],
                    )
                  // content: getAssetImage(context, "check_img.png", 179.h, 155.h,
                  //     boxFit: BoxFit.fill),
                )
                  }
                });




              }, EdgeInsets.symmetric(horizontal: horSpace, vertical: 30.h))
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
