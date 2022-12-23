import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/login/screen_check_mail.dart';
import 'package:flutter_parking_ui_new/app/routes/app_routes.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/constant.dart';
import '../../base/color_data.dart';
import '../../base/widget_utils.dart';

class ScreenChangePass extends StatefulWidget {
  const ScreenChangePass({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenChangePass();
  }
}

class _ScreenChangePass extends State<ScreenChangePass> {
  finish() {
    Constant.backToFinish(context);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);

    return getDetailWidget(context, () {
      finish();
    },
        "Change password",
        getPaddingWidget(
            EdgeInsets.symmetric(
                horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
            ListView(
              children: [
                getVerSpace(50.h),
                getDefaultTextFiled(context, "New Password", emailController,
                    getFontColor(context)),
                getVerSpace(30.h),
                getDefaultTextFiled(context, "Confirm Password",
                    confirmController, getFontColor(context)),
                getVerSpace(50.h),
                getButtonFigma(context, getAccentColor(context), true,
                    "Create Password", Colors.white, () {
                  Constant.sendToScreen(
                      ScreenCheckMail(
                          title: "Password Changed",
                          msg:
                              "Enter your register email to create new\npassword.",
                          btnText: "Go to home",
                          fun: () {
                            Constant.sendToNext(context, Routes.loginRoute);
                          },
                          image: "done.svg"),
                      context);
                }, EdgeInsets.zero),
              ],
            )));
  }
}
