import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../booking/booking_confirmation.dart';
import '../data/data_file.dart';
import '../model/model_payment_list.dart';
import '../model/model_slot_detail.dart';
import '../routes/app_routes.dart';

class PaymentCardScreen extends StatefulWidget {
  final String selected_date;
  final String selected_time;
  final int number_hours;
  final String selected_spot;
  final int selected_payement;
  PaymentCardScreen ({ Key? key, required this.selected_date  , required this.selected_time , required this.number_hours, required this.selected_spot, required this.selected_payement }): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PaymentCardScreen();
  }
}

class _PaymentCardScreen extends State<PaymentCardScreen> {
  finish() {
    Constant.backToFinish(context);
  }

  List<ModelPaymentList> allPaymentList = DataFile.getAllPaymentList();
  int selectedIndex = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getToolbarWidget(context, "Payment", () {}),
              Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      getVerSpace(30.h),
                      Center(
                          child: getAssetImage(
                              context, "card_img.png", 346.w, 231.w,
                              boxFit: BoxFit.fill)),
                      getVerSpace(40.h),
                      getPaddingWidget(edgeInsets,
                          buildTextFields(context, nameController, "Name")),
                      getVerSpace(30.h),
                      getPaddingWidget(
                          edgeInsets,
                          buildTextFields(
                              context, noController, "Card Number")),
                      getVerSpace(30.h),
                      Row(
                        children: [
                          Expanded(
                            child: getPaddingWidget(
                                edgeInsets,
                                buildTextFields(
                                    context, dateController, "MM/YY",
                                    formatter: [
                                      CreditCardExpirationDateFormatter()
                                    ])),
                            flex: 1,
                          ),
                          getHorSpace(20.w),
                          Expanded(
                            child: getPaddingWidget(
                                edgeInsets,
                                buildTextFields(context, cvvController, "CVV",
                                    maxSize: 3)),
                            flex: 1,
                          )
                        ],
                      )
                    ],
                  ),
                  flex: 1),
              getButtonFigma(context, getAccentColor(context), true,
                  "Continue", Colors.black, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingConfirmation(selected_date: widget.selected_date, selected_time: widget.selected_time, number_hours: widget.number_hours, selected_spot : widget.selected_spot , selected_payement: widget.selected_payement,)),
                    );
              }, EdgeInsets.symmetric(horizontal: horSpace, vertical: 30.h))
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  Widget buildTextFields(
      BuildContext context, TextEditingController controller, String hint,
      {List<TextInputFormatter>? formatter, int? maxSize}) {
    return TextFormField(
      inputFormatters: formatter,
      // validator: CardUtils.validateDate,

      controller: controller,
      style:
          buildTextStyle(context, getFontColor(context), FontWeight.w500, 16),
      maxLength: maxSize,
      decoration: InputDecoration(
          counterText: "",
          isDense: true,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: getAccentColor(context))),
          // enabledBorder: UnderlineInputBorder(
          //     borderSide: BorderSide(color: getAccentColor(context))),
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: getCurrentTheme(context).focusColor)),
          hintText: hint,
          hintStyle: buildTextStyle(
              context, getFontHint(context), FontWeight.w500, 16)),
    );
  }

  Widget getInfoItem(int type) {
    String title = (type == DataFile.slotUnAvailable)
        ? "Unavailable"
        : (type == DataFile.slotAvailable)
            ? "Available"
            : "Selected";
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
