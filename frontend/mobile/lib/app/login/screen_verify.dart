import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/routes/app_routes.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/constant.dart';
import '../../base/color_data.dart';
import '../../base/flutter_pin_code_fields.dart';
import '../../base/widget_utils.dart';

class ScreenVerify extends StatefulWidget {
  const ScreenVerify({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenVerify();
  }
}

class _ScreenVerify extends State<ScreenVerify> {
  finish() {
    Constant.backToFinish(context);
  }

  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);

    return getDetailWidget(context, () {
      finish();
    },
        "Verification",
        getPaddingWidget(
            EdgeInsets.symmetric(
                horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
            ListView(children: [
              PinCodeFields(
                length: 5,
                fieldBorderStyle: FieldBorderStyle.square,
                controller: codeController,
                activeBorderColor: getFontSkip(context),
                padding: EdgeInsets.zero,
                responsive: false,
                textStyle: TextStyle(
                  color: getFontColor(context),
                  fontSize: 24,
                  fontFamily: Constant.fontsFamily,
                  fontWeight: FontWeight.bold,
                ),
                borderWidth: 1.h,
                borderColor: getCurrentTheme(context).focusColor,
                borderRadius: BorderRadius.all(Radius.circular(18.h)),
                fieldWidth: 50.h,
                fieldHeight: 50.h,
                onComplete: (result) {},
              ),
              getVerSpace(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getCustomFont(
                      "Don’t recive code?", 16, getFontGreyColor(context), 1,
                      fontWeight: FontWeight.w600),
                  getCustomFont(" Resend", 16, getFontColor(context), 1,
                      fontWeight: FontWeight.w600)
                ],
              ),
              getVerSpace(50.h),
              getButtonFigma(context, getAccentColor(context), true, "Done",
                  getFontColor(context), () {
                Constant.sendToNext(context, Routes.changePassRoute);
              }, EdgeInsets.zero)
            ])));
  }
}
