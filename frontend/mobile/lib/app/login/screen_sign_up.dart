import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/pref_data.dart';
import '../../Models/RegisterModelRequest.dart';
import '../../Services/APIServices.dart';
import '../../base/constant.dart';
import '../../base/color_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../routes/app_routes.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenSignUp();
  }
}

class _ScreenSignUp extends State<ScreenSignUp> {
  finish() {
    Constant.backToFinish(context);
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController comfirmpassController = TextEditingController();

  ValueNotifier<bool> isShowPass = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);

    return getDetailWidget(context, () {
      finish();
    }, "Sign Up", buildList(context));
  }

  ListView buildList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
      shrinkWrap: true,
      primary: true,
      children: [
        getVerSpace(50.h),
        getDefaultTextFiled(
            context, "Name", fullNameController, getFontColor(context)),
        getVerSpace(30.h),
        getDefaultTextFiled(
            context, "Email", emailController, getFontColor(context)),
        getVerSpace(30.h),
        getDefaultCountryPickerTextFiled(
            context, "Phone number", mobileController, getFontColor(context)),
        getVerSpace(30.h),
        getDefaultTextFiled(
            context, "Password", passController, getFontColor(context)),
        getVerSpace(30.h),
        getDefaultTextFiled(
            context, "Confirm Password", comfirmpassController,
            getFontColor(context)),
        getVerSpace(50.h),
        getButtonFigma(
            context,
            getAccentColor(context),
            true,
            "Sign Up",
            Colors.white, () {
          //PrefData.setLogIn(true);
          if (passController.text == comfirmpassController.text) {

          }

          else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passwords not match")));
          }
          RegisterModelRequest model = RegisterModelRequest(full_name: fullNameController.text , email : emailController.text ,password: passController.text , phonenumber: mobileController.text );
          APIService.register(model).then((response) =>
          {
            if (response== true) {
              Constant.sendToNext(context, Routes.loginRoute)
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Register failed!")))
            }
          });

        },
            EdgeInsets.zero),
        getVerSpace(18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getCustomFont("Already have an account?", 14, getFontColor(context), 1,
                fontWeight: FontWeight.w400, textAlign: TextAlign.center),
            InkWell(
              onTap: () {
                Constant.sendToNext(context,Routes.loginRoute);
              },
              child: getCustomFont(" Login", 14, getFontColor(context), 1,
                  fontWeight: FontWeight.w700, textAlign: TextAlign.center),
            )
          ],
        )

      ],
    );
  }
}
