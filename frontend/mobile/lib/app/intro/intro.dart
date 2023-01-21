import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/dots_indicator.dart';
import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../data/data_file.dart';
import '../model/model_intro.dart';
import '../routes/app_routes.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IntroView();
  }
}

class _IntroView extends State<IntroView> {
  void backClick() {
    Constant.closeApp();
  }

  ValueNotifier selectedPage = ValueNotifier(0);
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // FetchPixels(context);
    Constant.setupSize(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
        horizontal: FetchPixels.getDefaultHorSpaceFigma(context));
    return WillPopScope(
        child: Scaffold(
          appBar: getInVisibleAppBar(),
          backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
          body: Column(children: [
            getVerSpace(10.h),
            getPaddingWidget(
                edgeInsets,
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      PrefData.setIntroAvailable(false);
                      Constant.sendToNext(context, Routes.loginRoute);
                    },
                    child: getCustomFont("Skip", 16, getFontColor(context), 1,
                        fontWeight: FontWeight.w400),
                  ),
                )),
            getVerSpace(12.h),

            buildExpand(edgeInsets),
            // getVerSpace(FetchPixels.getPixelHeight(80)),
            buildIndicator(),
            getVerSpace(30.h),
            getPaddingWidget(edgeInsets, buildNextButton(context)),
            getVerSpace(35.h)
          ]),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }

  Expanded buildExpand(EdgeInsets edgeInsets) {
    return Expanded(
      child: buildPageView(edgeInsets),
      flex: 1,
    );
  }

  ValueListenableBuilder buildNextButton(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return (selectedPage.value != DataFile.introList.length - 1)
            ? getButtonFigma(context, getAccentColor(context), true,
                S.of(context).next, getFontColor(context), () {
                selectedPage.value = selectedPage.value + 1;
                _controller.jumpToPage(selectedPage.value);
              }, EdgeInsets.zero)
            : getButtonFigma(context, getAccentColor(context), true,
                "Get Started", getFontColor(context), () {
                PrefData.setIntroAvailable(false);
                Constant.sendToNext(context, Routes.loginRoute);
              }, EdgeInsets.zero);
      },
      valueListenable: selectedPage,
    );
  }

  Widget buildIndicator() {
    return ValueListenableBuilder(
      valueListenable: selectedPage,
      builder: (context, value, child) {
        return SizedBox(
          height: 7.h,
          child: DotsIndicator(
            controller: _controller,
            selectedColor: getFontColor(context),
            itemCount: DataFile.introList.length,
            selectedPos: selectedPage.value,
            color: indicatorColor,
            onPageSelected: (int page) {},
          ),
        );
      },
    );
  }

  TextStyle getFontStyleWithColor({bool isSubTitle = false}) {
    return TextStyle(
        fontFamily: Constant.fontsFamily,
        fontSize: 28,
        color: (isSubTitle) ? "#C6C3FF".toColor() : getFontColor(context),
        fontWeight: FontWeight.bold,
        height: 1.46,
        fontStyle: FontStyle.normal);
  }

  PageView buildPageView(EdgeInsets edgeInsets) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (value) {
        selectedPage.value = value;
      },
      itemCount: DataFile.introList.length,
      itemBuilder: (context, index) {
        ModelIntro _introModel = DataFile.introList[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: getAssetImage(context, _introModel.image ?? "",
                    double.infinity, double.infinity,
                    boxFit:BoxFit.fill),
              ),
            ),
            getVerSpace(12.h),
            getPaddingWidget(
                edgeInsets,
                getCustomFont(
                    _introModel.title ?? "", 28, getFontColor(context), 1,
                    fontWeight: FontWeight.w700, textAlign: TextAlign.center)),
            getVerSpace(12.h),
            getPaddingWidget(
                edgeInsets,
                getMultilineCustomFont(
                  _introModel.description ?? "",
                  14,
                  getFontGreyColor(context),
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                )),
            getVerSpace(80.h)
          ],
        );
      },
    );
  }
}
