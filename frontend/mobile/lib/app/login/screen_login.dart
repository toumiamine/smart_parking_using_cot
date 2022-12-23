import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/pref_data.dart';
import '../../Models/LoginModelRequest.dart';
import '../../Services/APIServices.dart';
import '../../base/constant.dart';
import '../../base/color_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../routes/app_routes.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenLogin();
  }
}

class _ScreenLogin extends State<ScreenLogin> {
  finish() {
    Constant.closeApp();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  ValueNotifier<bool> isShowPass = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);

    return getDetailWidget(context, () {
      finish();
    }, "Login", buildList(context));
  }

  ListView buildList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
      shrinkWrap: true,
      primary: true,
      children: [
        getVerSpace(30.h),
        getDefaultTextFiled(
            context, "Email", emailController, getFontColor(context)),
        getVerSpace(30.h),
        ValueListenableBuilder(
          builder: (context, value, child) {
            return getPassTextFiled(context, "Password", passController,
                getFontColor(context), isShowPass.value, () {
              isShowPass.value = !isShowPass.value;
            });
          },
          valueListenable: isShowPass,
        ),
        getVerSpace(20.h),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Constant.sendToNext(context, Routes.forgotPassRoute);
            },
            child: getCustomFont(
                "Forgot Password?", 14, getFontColor(context), 1,
                fontWeight: FontWeight.w500, textAlign: TextAlign.end),
          ),
        ),
        getVerSpace(50.h),
        getButtonFigma(
            context, getAccentColor(context), true, "Login", Colors.white, () async {
          LoginModelRequest model = LoginModelRequest(email: emailController.text ,password: passController.text, grandType: 'PASSWORD' );
        await  APIService.login(model).then((response) => {
            if (response!= null) {
              PrefData.setLogIn(true),
              PrefData.setEmail(response["email"]),
              PrefData.setFullName(response["fullname"]),
              PrefData.setPhoneNumber(response["phone_number"]),
          Constant.sendToNext(context, Routes.homeScreenRoute)
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User not authorized", style: TextStyle(color: Colors.white),)
                    , backgroundColor: Colors.red,
                  )
              )
            }

          });
        }, EdgeInsets.zero),
        getVerSpace(40.h),
        SizedBox(
          width: double.infinity,
          child: getCustomFont("Or sign in with", 14, getFontColor(context), 1,
              fontWeight: FontWeight.w500, textAlign: TextAlign.center),
        ),
        getVerSpace(40.h),
        SizedBox(
          width: double.infinity,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 104.w,
                  height: 40.h,
                  decoration: getButtonDecoration(getCardColor(context),
                      withCorners: true,
                      corner: 6.h,
                      shadow: [
                        BoxShadow(
                            color: Color.fromRGBO(
                                34, 63, 143, 0.07999999821186066),
                            offset: Offset(-4, 5),
                            blurRadius: 16)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getSvgImageWithSize(context, "Google.svg", 20.h, 20.h,
                          fit: BoxFit.fill),
                      getHorSpace(11.h),
                      getCustomFont("Google", 14, getFontColor(context), 1,
                          fontWeight: FontWeight.w500)
                    ],
                  ),
                ),
                getHorSpace(30.h),
                Container(
                  width: 104.w,
                  height: 40.h,
                  decoration: getButtonDecoration(getCardColor(context),
                      withCorners: true,
                      corner: 6.h,
                      shadow: [
                        BoxShadow(
                            color: Color.fromRGBO(
                                34, 63, 143, 0.07999999821186066),
                            offset: Offset(-4, 5),
                            blurRadius: 16)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getSvgImageWithSize(context, "Facebook.svg", 20.h, 20.h,
                          fit: BoxFit.fill),
                      getHorSpace(11.h),
                      getCustomFont("facebook", 14, getFontColor(context), 1,
                          fontWeight: FontWeight.w500)
                    ],
                  ),
                ),
                // Expanded(
                //   child: getButtonFigma(context, Colors.white, true, "Google",
                //       getFontColor(context), () {}, EdgeInsets.zero,
                //       isIcon: true,
                //       icons: "google.svg",
                //       withGradient: false,
                //       shadow: [
                //         BoxShadow(
                //             color: Colors.black.withOpacity(0.05),
                //             blurRadius: 8,
                //             spreadRadius: 2)
                //       ]),
                //   flex: 1,
                // ),
                // getHorSpace(FetchPixels.getDefaultHorSpaceFigma(context)),
                // Expanded(
                //   child: getButtonFigma(context, Colors.white, true, "Facebook",
                //       getFontColor(context), () {}, EdgeInsets.zero,
                //       isIcon: true,
                //       icons: "facebook.svg",
                //       withGradient: false,
                //       shadow: [
                //         BoxShadow(
                //             color: Colors.black.withOpacity(0.05),
                //             blurRadius: 8,
                //             spreadRadius: 2)
                //       ]),
                //   flex: 1,
                // ),
              ]),
        ),
        getVerSpace(80.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getCustomFont(
                "Don't have an account?", 14, getFontColor(context), 1,
                textAlign: TextAlign.start, fontWeight: FontWeight.w500),
            InkWell(
              onTap: () {
                Constant.sendToNext(context, Routes.signUpRoute);
              },
              child: getCustomFont(" Sign Up", 16, getFontColor(context), 1,
                  textAlign: TextAlign.start, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
