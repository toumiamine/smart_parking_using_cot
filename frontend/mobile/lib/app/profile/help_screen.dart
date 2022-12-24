import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpScreen();
  }
}

class _HelpScreen extends State<HelpScreen> {
  finish() {
    Constant.backToFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);
    return WillPopScope(
        child: Scaffold(
            body: Column(
          children: [
            getToolbarWidget(context, "Help&Support", () {}),
            Expanded(
              child: ListView(
                padding: edgeInsets,
                shrinkWrap: true,
                children: [
                  getVerSpace(20.h),
                  getMultilineCustomFont(
                      "This app is made for CoT project",
                      16,
                      getFontGreyColor(context),
                      fontWeight: FontWeight.w500),
                  getVerSpace(10.h),
                ],
              ),
              flex: 1,
            )
          ],
        )),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
