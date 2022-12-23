import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';

class GalleryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GalleryScreen();
  }
}

class _GalleryScreen extends State<GalleryScreen> {
  PageController _pageController = PageController();
  int pageCount = 3;

  finish() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          appBar: getInVisibleAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(10.h),
              getPaddingWidget(
                  edgeInsets,
                  getBackIcon(context, () {
                    finish();
                  }, colors: getFontColor(context))),
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: horSpace, vertical: 20.h),
                        width: double.infinity,
                        height: double.infinity,
                        child: getCircularImage(context, double.infinity,
                            double.infinity, 18.h, "imgDetail.png",
                            boxFit: BoxFit.cover),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 3),
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      int pos = _pageController.page!.toInt();
                      if (pos > 0) {
                        print("getpos===$pos");
                        pos--;
                        _pageController.animateToPage(pos,
                            curve: Curves.decelerate,
                            duration: Duration(milliseconds: 300));
                      }
                      print("getpos===$pos");
                      // _pageController.jumpToPage(pos-1);
                    },
                    child: getSvgImageWithSize(context, "prev.svg", 40.h, 40.h,
                        fit: BoxFit.fill),
                  ),
                  getHorSpace(20.w),
                  InkWell(
                    onTap: () {
                      int pos = _pageController.page!.toInt();
                      if (pos < pageCount) {
                        print("getpos===$pos");
                        pos++;
                        _pageController.animateToPage(pos,
                            curve: Curves.decelerate,
                            duration: Duration(
                                milliseconds:
                                    300)); // for animated jump. Requires a curve and a duration
                      }
                    },
                    child: getSvgImageWithSize(context, "next.svg", 40.h, 40.h,
                        fit: BoxFit.fill),
                  )
                ],
              ),
              getVerSpace(30.h)
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
