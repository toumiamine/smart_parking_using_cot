import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/login/screen_check_mail.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/constant.dart';
import '../../base/color_data.dart';
import '../../base/widget_utils.dart';

class ScreenForgotPass extends StatefulWidget {
  const ScreenForgotPass({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenForgotPass();
  }
}

class _ScreenForgotPass extends State<ScreenForgotPass> {
  finish() {
    Constant.backToFinish(context);
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);

    return getDetailWidget(context, () {
      finish();
    },
        "Forgot password",
        getPaddingWidget(
            EdgeInsets.symmetric(
                horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
            ListView(
              children: [
                getVerSpace(50.h),
                getDefaultTextFiled(
                    context, "Email", emailController, getFontColor(context)),
                getVerSpace(50.h),
                getButtonFigma(context, getAccentColor(context), true, "Send",
                    Colors.white, () {
                  Constant.sendToScreen(
                      ScreenCheckMail(
                          title: "Check Your Email",
                          msg:
                              "We have Sent a password recovery\ninstruction to you email",
                          btnText: "Ok",
                          fun: finish(),
                          image: "mail.svg"),
                      context);
                }, EdgeInsets.zero),
                getVerSpace(20.h),
                getButtonFigma(
                    context,
                    Colors.transparent,
                    true,
                    "Back to login",
                    getFontColor(context),
                    () {},
                    EdgeInsets.zero,
                    isBorder: true,
                    borderColor: getFontColor(context)),
              ],
            )));
  }
}
