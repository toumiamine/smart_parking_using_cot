import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parking_ui_new/base/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Constant {
  static String assetImagePath = "assets/images/";
  static String assetImagePathNight = "assets/imagesNight/";
  static const String fontsFamily = "Montserrat";
  static const String fontsFamilySansita = "Sansita-Regular";
  static const String digitalFontsFamily = "digitalmono";

  static void setupSize(BuildContext context,
      {double width = 414, double height = 896}) {
    ScreenUtil.init(context,
        designSize: Size(width, height), minTextAdapt: true);
  }

  static backToPrev(BuildContext context) {
    // Navigator.of(context).pop();
    Get.back();
  }


  static sendToNext(BuildContext context, String route, {Object? arguments}) {
    if (arguments != null) {
      Get.toNamed(route, arguments: arguments);
    } else {
      Get.toNamed(route);
    }
  }


  static double getWidthPercentSize(double percent) {
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    return (percent * screenWidth) / 100;
  }

  static double getHeightPercentSize(double percent) {
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    return (percent * screenHeight) / 100;
  }

  static double getToolbarTopHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static backToFinish(BuildContext context) {
    // Navigator.of(context).pop();
    Get.back();
  }

  static formatTime(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  static closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}
