import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/data/data_file.dart';
import 'package:flutter_parking_ui_new/app/routes/app_routes.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/pref_data.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../model/model_category.dart';

class TabProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabProfile();
  }
}

class _TabProfile extends State<TabProfile> {

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
        horizontal: FetchPixels.getDefaultHorSpaceFigma(context));

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          getToolbarWidget(context, "Profile", () {}),
          Expanded(
            child: ListView(
              padding: edgeInsets,
              shrinkWrap: true,
              primary: true,
              children: [
                getVerSpace(50.h),
                buildProfilePhotoWidget(context),
                getVerSpace(30.h),
                buildProfileRowItem(context, "My Profile", () {
                  Constant.sendToNext(context, Routes.myProfileScreen);
                }),
                buildProfileRowItem(context, "Settings", () {
                  Constant.sendToNext(context, Routes.settingScreen);
                }),
              ],
            ),
            flex: 1,
          ),
          getVerSpace(20.h),
          getButtonFigma(
              context, getAccentColor(context), true, "Log out", Colors.black,
              () {
            Get.bottomSheet(
                SizedBox.fromSize(
                  size: Size(double.infinity, 356.h),
                  child: getPaddingWidget(
                      edgeInsets,
                      Column(
                        children: [
                          getVerSpace(10.h),
                          SizedBox(
                            width: 40.w,
                            child: Divider(
                              color: getFontGreyColor(context),
                              thickness: 4.h,
                            ),
                          ),
                          getVerSpace(20.h),
                          getCustomFont(
                            "Log out",
                            22,
                            getFontColor(context),
                            1,
                            fontWeight: FontWeight.w600,
                          ),
                          getVerSpace(20.h),
                          Divider(
                            thickness: 2.h,
                            color: dividerColor,
                          ),
                          getVerSpace(20.h),
                          getMultilineCustomFont(
                            "Are you sure you want to logout?",
                            18,
                            getFontColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                          getVerSpace(20.h),
                          getButtonFigma(
                              context,
                              getAccentColor(context),
                              true,
                              "Yes, Logout",
                              Colors.black,
                              () {
                                PrefData.setLogIn(false);
                                Constant.backToFinish(context);
                                Constant.sendToNext(context,Routes.homeRoute);

                              },
                              EdgeInsets.zero),
                          getVerSpace(12.h),
                          getButtonFigma(
                              context,
                              Colors.transparent,
                              true,
                              "Cancel",
                              getFontColor(context),
                              () {
                                Constant.backToFinish(context);
                              },
                              EdgeInsets.zero,
                              isBorder: true,
                              borderColor: getFontColor(context)),
                          Expanded(
                            child: getVerSpace(0),
                            flex: 1,
                          )
                        ],
                      )),
                ),
                backgroundColor: getCardColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.h)),
                ));
          }, edgeInsets),
          getVerSpace(40.h)
        ],
      ),
    );
  }
}
