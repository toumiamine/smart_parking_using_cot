import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  checkLogin() async {
    bool isLogin = await PrefData.isLogIn();
    bool isFirst = await PrefData.isIntroAvailable();
    print("chkval===$isLogin===$isFirst");
    Timer(
      const Duration(seconds: 1),
      () {
        (isLogin)
            ? Constant.sendToNext(context, Routes.homeScreenRoute)
            : (isFirst)
                ? Constant.sendToNext(context, Routes.introRoute)
                : Constant.sendToNext(context, Routes.loginRoute);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkLogin();

    // PrefData.isLogIn().then((value) {
    //   Timer(
    //     const Duration(seconds: 1),
    //     () {
    //       (value)
    //           ? Constant.sendToNext(context, Routes.homeScreenRoute)
    //           : Constant.sendToNext(context, Routes.introRoute);
    //     },
    //   );
    // });
  }

  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    // FetchPixels(context);
    Constant.setupSize(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
        horizontal: FetchPixels.getDefaultHorSpaceFigma(context));

    return WillPopScope(
        child: Scaffold(
          appBar: getInVisibleAppBar(color: yellowBgColor),
          backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: yellowBgColor,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(80.h))),
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(80.h)),
                  child: getAssetImage(context, "welcomeScreen.png",
                      double.infinity, double.infinity,
                      boxFit: BoxFit.fill),
                ),
              )),
              getVerSpace(37.h),
              getPaddingWidget(
                  edgeInsets,
                  getCustomFont("Welcome to", 44, getFontColor(context), 1,
                      fontWeight: FontWeight.w400,
                      fontFamily: Constant.fontsFamilySansita)),
              getVerSpace(8.h),
              getPaddingWidget(
                  edgeInsets,
                  getCustomFont(
                    "Parking",
                    44,
                    accentColor,
                    1,
                    fontWeight: FontWeight.w600,
                  )),
              getVerSpace(8.h),
            getPaddingWidget(edgeInsets,   getMultilineCustomFont(
                "Find your best parking !",
                14,
                getFontColor(context),
                fontWeight: FontWeight.w500)),
              getVerSpace(50.h),

            ],
          ),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }

  Column buildColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getSvgImageWithSize(context, "Logo.svg", 154.h, 172.h,
            fit: BoxFit.fill),
      ],
    );
  }
}
