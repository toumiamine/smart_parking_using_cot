import 'package:flutter_parking_ui_new/base/slider.dart' as sliders;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../data/data_file.dart';
import '../model/model_payment_list.dart';
import '../routes/app_routes.dart';

class ExtendTimeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExtendTimeScreen();
  }
}

class _ExtendTimeScreen extends State<ExtendTimeScreen> {
  finish() {
    Constant.backToFinish(context);
  }

  ValueNotifier<double> _progressVal = ValueNotifier(1);
  List<ModelPaymentList> allPaymentList = DataFile.getAllPaymentList();
  int selectedIndex = 0;

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
              getToolbarWidget(context, "Extend Parking Time", () {}),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      getVerSpace(30.h),
                      getPaddingWidget(
                          edgeInsets,
                          getCustomFont(
                              "Add Time", 16, getFontColor(context), 1,
                              fontWeight: FontWeight.w500)),
                      getVerSpace(15.h),
                      getPaddingWidget(
                          edgeInsets,
                          ValueListenableBuilder(
                            builder: (context, value, child) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    showValueIndicator:
                                        ShowValueIndicator.onlyForContinuous,
                                    valueIndicatorColor: Colors.transparent,
                                    valueIndicatorTextStyle: buildTextStyle(
                                        context,
                                        getFontColor(context),
                                        FontWeight.w500,
                                        16) // This is what you are asking for

                                    ),
                                child: sliders.Slider(
                                  label: "${_progressVal.value.toInt()} hour",
                                  thumbColor: getAccentColor(context),
                                  activeColor: getAccentColor(context),
                                  inactiveColor:
                                      getCurrentTheme(context).focusColor,
                                  onChanged: (value) {
                                    _progressVal.value = value;
                                  },
                                  value: _progressVal.value,
                                  max: 10,
                                  min: 1,
                                ),
                              );
                            },
                            valueListenable: _progressVal,
                          )),
                      getVerSpace(15.h),
                      getPaddingWidget(
                          edgeInsets,
                          getCustomFont("Choose Payment Method", 16,
                              getFontColor(context), 1,
                              fontWeight: FontWeight.w500)),
                      getVerSpace(15.h),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          ModelPaymentList paymentModel = allPaymentList[index];
                          return buildPaymentContainer(edgeInsets, horSpace,
                              index, context, paymentModel, () {
                            setState(() {
                              selectedIndex = index;
                            });
                          }, selectedIndex);
                        },
                        itemCount: allPaymentList.length,
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                  flex: 1),
              getVerSpace(25.h),
              getButtonFigma(context, getAccentColor(context), true,
                  "Confirm Payment", Colors.black, () {
                Constant.sendToNext(context, Routes.homeScreenRoute);
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
