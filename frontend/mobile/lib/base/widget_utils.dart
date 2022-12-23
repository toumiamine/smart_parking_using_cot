import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../app/model/model_payment_list.dart';
import '../app/notifier/dark_mode.dart';
import 'color_data.dart';
import 'constant.dart';
import 'country_code_picker.dart';

void showCustomToast(String texts, BuildContext context) {
  Fluttertoast.showToast(
      msg: texts,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12.0.sp);
}

Widget buildPaymentContainer(
    EdgeInsets edgeInsets,
    double horSpace,
    int index,
    BuildContext context,
    ModelPaymentList paymentModel,
    Function function,
    int selectedVal) {
  return Container(
    padding: edgeInsets,
    margin: EdgeInsets.symmetric(horizontal: horSpace, vertical: 10.h),
    decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(61, 61, 61, 0.11999999731779099),
              offset: Offset(-4, 8),
              blurRadius: 25)
        ]),
    width: double.infinity,
    height: 64.h,
    child: InkWell(
      onTap: () {
        function();
      },
      child: Row(
        children: [
          getSvgImageWithSize(context, paymentModel.image, 24.h, 24.h,
              fit: BoxFit.fill),
          getHorSpace(30.w),
          Expanded(
            child: getCustomFont(
                paymentModel.title, 16, getFontColor(context), 1,
                textAlign: TextAlign.start),
            flex: 1,
          ),
          (selectedVal == index)
              ? Icon(
                  Icons.radio_button_checked_rounded,
                  color: getFontColor(context),
                  size: 24.h,
                )
              : Icon(
                  Icons.radio_button_off_rounded,
                  color: greyIconColor,
                  size: 24.h,
                )
        ],
      ),
    ),
  );
}

Widget buildProfileRowItem(
    BuildContext context, String title, Function function) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      width: double.infinity,
      height: 64.h,
      decoration: getButtonDecoration(
        getGreyCardColor(context),
        withCorners: true,
        corner: 12.h,
      ),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: getCustomFont(title, 16, getFontColor(context), 1,
                fontWeight: FontWeight.w600, textAlign: TextAlign.start),
            flex: 1,
          ),
          getSvgImageWithSize(context, "arrow_right_profile.svg", 16.h, 16.h,
              color: getFontColor(context))
        ],
      ),
    ),
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight,
    bool horFactor = false}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize.sp,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: fontFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
    // textScaleFactor: 0.5,
    // textScaleFactor: FetchPixels.getTextScale(horFactor: horFactor),
  );
}

TextStyle buildTextStyle(BuildContext context, Color fontColor,
    FontWeight fontWeight, double fontSize) {
  return TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: Constant.fontsFamily,
    fontSize: fontSize.sp,
  );
}

DecorationImage getDecorationAssetImage(BuildContext buildContext, String image,
    {BoxFit fit = BoxFit.contain}) {
  var darkThemeProvider = Provider.of<DarkMode>(buildContext);

  return DecorationImage(
    image: AssetImage(((darkThemeProvider.darkMode &&
                darkThemeProvider.assetList.contains(image))
            ? Constant.assetImagePathNight
            : Constant.assetImagePath) +
        image),
    fit: fit,
    // scale: FetchPixels.getScale()
  );
}

Widget getCloseButton(BuildContext context, Function function) {
  return InkWell(
    onTap: () {
      function();
    },
    child: getSvgImageWithSize(context, "Close.svg", 24.h, 24.h),
  );
}

Widget getMultilineCustomFont(String text, double fontSize, Color fontColor,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight = 1.5}) {
  return Text(
    text,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize.sp,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: Constant.fontsFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

double getButtonHeight() {
  return 150.h;
}

double getButtonHeightFigma() {
  return 60.h;
}

Widget getButtonContainer(
    BuildContext context, IconData iconData, Function function,
    {double size = 40, double iconSize = 24}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      width: size.h,
      decoration:
          BoxDecoration(color: "#FFF3F3".toColor(), shape: BoxShape.circle),
      height: size.h,
      child: Center(
        child: Icon(iconData, size: iconSize.h, color: getAccentColor(context)),
      ),
    ),
  );
}

Widget getEmptyWidget(BuildContext context, String image, String title,
    String description, String btnTxt, Function function,
    {bool withButton = true}) {
  double imgSize = 120.h;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      getSvgImageWithSize(context, image, imgSize, imgSize),
      getVerSpace(30.h),
      getCustomFont(title, 22, getFontColor(context), 1,
          fontWeight: FontWeight.w700, textAlign: TextAlign.center),
      getVerSpace(10.h),
      getMultilineCustomFont(description, 16, getFontColor(context),
          fontWeight: FontWeight.w500, textAlign: TextAlign.center),
      (withButton)
          ? InkWell(
              onTap: () {
                function();
              },
              child: Container(
                  margin: EdgeInsets.only(top: 40.h),
                  width: 192.h,
                  height: 60.h,
                  decoration: getButtonDecoration(Colors.transparent,
                      withCorners: true,
                      withBorder: true,
                      borderColor: getAccentColor(context),
                      corner: 14.h),
                  child: Center(
                      child: getMultilineCustomFont(
                          btnTxt, 16, getAccentColor(context),
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center))))
          : getHorSpace(0)
    ],
  );
}

double getEditHeightFigma() {
  return 46.h;
}

double getEditFontSizeFigma() {
  return 14;
}

double getEditRadiusSize() {
  return 35.h;
}

double getEditRadiusSizeFigma() {
  return 12.h;
}

double getEditIconSize() {
  return 60;
}

double getEditIconSizeFigma() {
  return 24;
}

double getButtonCorners() {
  return 35.h;
}

double getButtonCornersFigma() {
  return 30.h;
}
Widget getToolbarIcons(BuildContext context, String name, Function click,
    {bool withTheme = true, Color? color}) {
  return InkWell(
    child: getSvgImageWithSize(context, name, 24.h, 24.h,
        color: (color == null) ? getFontColor(context) : color),
    onTap: () {
      click();
    },
  );
}

double getButtonFontSizeFigma() {
  return 20;
}

ShapeDecoration getButtonDecoration(Color bgColor,
    {withBorder = false,
    Color borderColor = Colors.transparent,
    bool withCorners = true,
    double corner = 0,
    double cornerSmoothing = 1.1,
    List<BoxShadow> shadow = const []}) {
  return ShapeDecoration(
      color: bgColor,
      shadows: shadow,
      shape: SmoothRectangleBorder(
          side: BorderSide(
              width: 1, color: (withBorder) ? borderColor : Colors.transparent),
          borderRadius: SmoothBorderRadius(
              cornerRadius: (withCorners) ? corner : 0,
              cornerSmoothing: (withCorners) ? cornerSmoothing : 0)));
}

ShapeDecoration getButtonDecorationWithGradient(Color bgColor,
    {withBorder = false,
    Color borderColor = Colors.transparent,
    bool withCorners = true,
    double corner = 0,
    double cornerSmoothing = 1.1,
    List<BoxShadow> shadow = const []}) {
  return ShapeDecoration(
      shadows: shadow,
      gradient: getGradients(),
      shape: SmoothRectangleBorder(
          side: BorderSide(
              width: 1, color: (withBorder) ? borderColor : Colors.transparent),
          borderRadius: SmoothBorderRadius(
              cornerRadius: (withCorners) ? corner : 0,
              cornerSmoothing: (withCorners) ? cornerSmoothing : 0)));
}

getGradients() {
  return LinearGradient(colors: [
    "#FF8080".toColor(),
    "#F44144".toColor(),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

Widget getCenterTitleHeader(BuildContext context, String title,
    EdgeInsets edgeInsets, Function backClick,
    {bool visibleMore = false,
    String moreImg = "More.svg",
    Function? moreFunc}) {
  return getPaddingWidget(
      edgeInsets,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getBackIcon(context, () {
            backClick();
          }),
          Expanded(
            child: getCustomFont(title, 22, getFontColor(context), 1,
                textAlign: TextAlign.center, fontWeight: FontWeight.w600),
            flex: 1,
          ),
          Visibility(
            visible: visibleMore,
            maintainAnimation: true,
            maintainState: true,
            maintainSize: true,
            child: getBackIcon(context, () {
              moreFunc!();
            }, icon: moreImg),
          )
        ],
      ));
}

Widget buildProfilePhotoWidget(BuildContext context,
    {Function? function, String icons = "ic_edit.svg"}) {
  return Center(
    child: Container(
      width: 102.h,
      height: 100.h,
      child: Stack(
        children: [
          getCircleImage(context, "profile.png", double.infinity),
        ],
      ),
    ),
  );
}

Widget getToolbarWidget(BuildContext context, String title, Function fun) {
  SmoothRadius smoothRadius =
      SmoothRadius(cornerRadius: 90.h, cornerSmoothing: 0);
  return Container(
    width: double.infinity,
    height: 132.h,
    padding: EdgeInsets.only(
        left: FetchPixels.getDefaultHorSpaceFigma(context),
        right: FetchPixels.getDefaultHorSpaceFigma(context),
        bottom: 30.h),
    decoration: ShapeDecoration(
        color: getAccentColor(context),
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.only(bottomRight: smoothRadius))),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: getBackIcon(context, () {
            fun();
          }, colors: Colors.black),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: getCustomFont(title, 22, getFontColor(context), 1,
              fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

Widget getDetailWidget(BuildContext context, Function backClick, String title,
    Widget childWidget) {
  double topView = 291.h;
  double radius = topView / 2;
  SmoothRadius smoothRadius =
      SmoothRadius(cornerRadius: radius, cornerSmoothing: 0.6);

  return WillPopScope(
      child: Scaffold(
        backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: topView,
                decoration: ShapeDecoration(
                    color: getAccentColor(context),
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                            bottomRight: smoothRadius))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 109.h,
                      height: 109.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              getCurrentTheme(context).scaffoldBackgroundColor),
                      child: Center(
                        child: Image.asset("assets/images/Marker.png" , height: 53.h, width: 60.h)
                      ),
                    ),
                    getVerSpace(20.h),
                    getCustomFont(title, 28, getFontColor(context), 1,
                        fontWeight: FontWeight.w700)
                  ],
                ),
              ),
              Expanded(
                child: childWidget,
                flex: 1,
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        backClick();
        return false;
      });
}

Widget getCircleImage(BuildContext context, String imgName, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      child: getAssetImage(context, imgName, double.infinity, double.infinity),
    ),
  );
}

Widget getSvgImage(BuildContext context, String image, double size,
    {Color? color}) {
  var darkThemeProvider = Provider.of<DarkMode>(context);

  return SvgPicture.asset(
    ((darkThemeProvider.darkMode && darkThemeProvider.assetList.contains(image))
            ? Constant.assetImagePathNight
            : Constant.assetImagePath) +
        image,
    color: color,
    width: size.w,
    height: size.h,
    fit: BoxFit.fill,
  );
}

Widget getTopViewHeader(BuildContext context, String titleMain, String titleSub,
    {bool visibleSub = true}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getVerSpace(80.h),
      getHeaderTitle(context, titleMain),
      (!visibleSub) ? getVerSpace(0) : getVerSpace(30.h),
      (!visibleSub) ? getVerSpace(0) : getSubHeaderTitle(context, titleSub),
      getVerSpace(60.h),
    ],
  );
}

Widget getHeaderTitle(BuildContext context, String str) {
  return getCustomFont(str, 55, getFontColor(context), 1,
      fontWeight: FontWeight.w900, textAlign: TextAlign.start);
}

Widget getHeaderTitleCustom(BuildContext context, String str) {
  return getCustomFont(str, 28, getFontColor(context), 1,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.start,
      horFactor: false);
}

Widget getSubHeaderTitle(BuildContext context, String title) {
  return getCustomFont(title, 40, getFontColor(context), 2,
      fontWeight: FontWeight.w400);
}

Widget getSvgImageWithSize(
    BuildContext context, String image, double width, double height,
    {Color? color, BoxFit fit = BoxFit.fill, bool listen = true}) {
  var darkThemeProvider = Provider.of<DarkMode>(context, listen: listen);
  return SvgPicture.asset(
    ((darkThemeProvider.darkMode && darkThemeProvider.assetList.contains(image))
            ? Constant.assetImagePathNight
            : Constant.assetImagePath) +
        image,
    color: color,
    width: width,
    height: height,
    fit: fit,
  );
}

Widget getProfileTopView(
  BuildContext context,
  Function backClick,
  String title, {
  bool visibleMore = false,
  Function? moreFunc,
  bool visibleEdit = false,
  Function? funcEdit,
}) {
  double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
  return SizedBox(
    height: (223 + 9).h,
    child: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 201.h,
          child: getSvgImage(
            context,
            "profile_rect.svg",
            double.infinity,
          ),
        ),
        getCenterTitleHeader(
            context,
            title,
            EdgeInsets.only(
                left: horSpace,
                right: horSpace,
                top: Constant.getToolbarTopHeight(context) + 10.h), () {
          backClick();
        }, visibleMore: visibleMore, moreFunc: moreFunc),
        Padding(
          padding: EdgeInsets.only(left: horSpace),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 120.h,
              height: 120.h,
              child: Stack(
                children: [
                  getCircleImage(
                      context, "profile_Setting.png", double.infinity),
                  Visibility(
                    visible: visibleEdit,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          funcEdit!();
                        },
                        child: getSvgImageWithSize(
                            context, "edit_icon.svg", 36.h, 36.h),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget getBackIcon(BuildContext context, Function function,
    {String icon = "arrow_back.svg", Color? colors}) {
  return InkWell(
      onTap: () {
        function();
      },
      child: getSvgImageWithSize(context, icon, 24.h, 24.h, color: colors));
}

Widget getAssetImage(
    BuildContext context, String image, double width, double height,
    {Color? color, BoxFit boxFit = BoxFit.contain, bool listen = true}) {
  var darkThemeProvider = Provider.of<DarkMode>(context, listen: listen);
  return Image.asset(
    ((darkThemeProvider.darkMode && darkThemeProvider.assetList.contains(image))
            ? Constant.assetImagePathNight
            : Constant.assetImagePath) +
        image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    // scale: FetchPixels.getScale(),
  );
}

Widget getDialogDividerBottom(BuildContext context) {
  return Container(
    width: 134.w,
    decoration: getButtonDecoration(getFontColor(context),
        withCorners: true, withBorder: false, corner: 5.h),
    height: 5.h,
  );
}

Widget getDialogDividerTop(BuildContext context) {
  return Container(
    width: 48.w,
    decoration: getButtonDecoration(getCardColor(context),
        withCorners: true, withBorder: false, corner: 4.h),
    height: 4.h,
  );
}

Widget getTextFieldView(BuildContext context, Widget widget, bool minLines,
    EdgeInsetsGeometry margin) {
  double height = getEditHeightFigma();
  return Container(
    height: (minLines) ? (height * 2.2) : height,
    margin: margin,
    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
    alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
    decoration: ShapeDecoration(
      color: Colors.transparent,
      shape: SmoothRectangleBorder(
        side: BorderSide(color: getCurrentTheme(context).focusColor, width: 1),
        borderRadius: SmoothBorderRadius(
          cornerRadius: getEditRadiusSize(),
          cornerSmoothing: 0.8,
        ),
      ),
    ),
    child: widget,
  );
}

Widget getTextFieldViewCustom(BuildContext context, Widget widget,
    bool minLines, EdgeInsetsGeometry margin) {
  double height = getEditHeightFigma();
  return Container(
    height: (minLines) ? (height * 2.2) : height,
    margin: margin,
    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
    alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
    decoration: ShapeDecoration(
      color: Colors.transparent,
      shape: SmoothRectangleBorder(
        side: BorderSide(color: getCurrentTheme(context).focusColor, width: 1),
        borderRadius: SmoothBorderRadius(
          cornerRadius: getEditRadiusSizeFigma(),
          cornerSmoothing: 0.8,
        ),
      ),
    ),
    child: widget,
  );
}

Widget getDefaultTextFiled(BuildContext context, String s,
    TextEditingController textEditingController, Color fontColor,
    {bool withPrefix = false,
    String imgName = "",
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero}) {
  double height = getEditHeightFigma();

  return StatefulBuilder(
    builder: (context, setState) {
      // final mqData = MediaQuery.of(context);
      // final mqDataNew =
      // mqData.copyWith(textScaleFactor: FetchPixels.getTextScale());
      return Container(
        height: (minLines) ? (height * 2.2) : height,
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
        alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
        // decoration: ShapeDecoration(
        //   color: Colors.transparent,
        //   shape: SmoothRectangleBorder(
        //     side: BorderSide(
        //         color: isAutoFocus
        //             ? getAccentColor(context)
        //             : getCurrentTheme(context).focusColor,
        //         width: 1),
        //     borderRadius: SmoothBorderRadius(
        //       cornerRadius: getEditRadiusSize(),
        //       cornerSmoothing: 0.8,
        //     ),
        //   ),
        // ),
        child: SizedBox(
              height: double.infinity,
              child: (minLines)
                  ? TextField(
                      // minLines: null,
                      // maxLines: null,

                      maxLines: (minLines) ? null : 1,
                      controller: textEditingController,
                      autofocus: false,
                      textAlign: TextAlign.start,
                      // expands: true,
                      expands: minLines,
                      // textAlignVertical:(minLines)?TextAlignVertical.top:TextAlignVertical.center,
                      style: TextStyle(
                          fontFamily: Constant.fontsFamily,
                          color: fontColor,
                          fontWeight: FontWeight.w400,
                          fontSize: getEditFontSizeFigma().sp),
                      decoration: InputDecoration(
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          filled: true,
                          // fillColor: Colors.green,
                          prefixIcon: (withPrefix)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 3.w),
                                  child: getSvgImage(
                                      context, imgName, getEditIconSize()),
                                )
                              : getHorSpace(0),
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),
                          // border: InputBorder.none,
                          isDense: true,
                          // focusedBorder: InputBorder.none,
                          // enabledBorder: InputBorder.none,
                          // errorBorder: InputBorder.none,
                          // disabledBorder: InputBorder.none,
                          hintText: s,
                          // prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                          hintStyle: TextStyle(
                              fontFamily: Constant.fontsFamily,
                              color: getFontHint(context),
                              fontWeight: FontWeight.w400,
                              fontSize: getEditFontSizeFigma().sp)),
                    )
                  : Center(
                      child: TextField(
                      // minLines: null,
                      // maxLines: null,
                      maxLines: (minLines) ? null : 1,
                      controller: textEditingController,
                      autofocus: false,
                      textAlign: TextAlign.start,
                      // expands: true,
                      expands: minLines,
                      // textAlignVertical:(minLines)?TextAlignVertical.top:TextAlignVertical.center,
                      style: TextStyle(
                          fontFamily: Constant.fontsFamily,
                          color: fontColor,
                          fontWeight: FontWeight.w400,
                          fontSize: getEditFontSizeFigma().sp),
                      decoration: InputDecoration(
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          // filled: true,
                          // fillColor: Colors.green,
                          prefixIcon: (withPrefix)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 3.w),
                                  child: getSvgImage(
                                      context, imgName, getEditIconSize()),
                                )
                              : getHorSpace(0),
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),

                          // border: InputBorder.none,
                          isDense: true,
                          hintText: s,
                          hintStyle: TextStyle(
                              fontFamily: Constant.fontsFamily,
                              color: getFontHint(context),
                              fontWeight: FontWeight.w400,
                              fontSize: getEditFontSizeFigma().sp)),
                    )),

            ),
      );
    },
  );
}

Widget getDefaultTextFiledFigma(BuildContext context, String s,
    TextEditingController textEditingController, Color fontColor,
    {bool withPrefix = false,
    String imgName = "",
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool isDisable = false}) {
  double height = getEditHeightFigma();
  FocusNode myFocusNode = FocusNode();
  bool isAutoFocus = false;
  return StatefulBuilder(
    builder: (context, setState) {

      return Container(
        height: (minLines) ? (height * 2.2) : height,
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
        alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: SmoothRectangleBorder(
            side: BorderSide(
                color: isAutoFocus
                    ? getAccentColor(context)
                    : getCurrentTheme(context).focusColor,
                width: 1.h),
            borderRadius: SmoothBorderRadius(
              cornerRadius: getEditRadiusSizeFigma(),
              cornerSmoothing: 0.8,
            ),
          ),
        ),
        child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                setState(() {
                  isAutoFocus = true;
                  myFocusNode.canRequestFocus = true;
                });
              } else {
                setState(() {
                  isAutoFocus = false;
                  myFocusNode.canRequestFocus = false;
                });
              }
            },
            child: AbsorbPointer(
              absorbing: isDisable,
              child: SizedBox(
                height: double.infinity,
                child: (minLines)
                    ? TextField(
                        maxLines: (minLines) ? null : 1,
                        controller: textEditingController,
                        autofocus: false,
                        focusNode: myFocusNode,
                        textAlign: TextAlign.start,
                        expands: minLines,
                        style: TextStyle(
                            fontFamily: Constant.fontsFamily,
                            color: fontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: getEditFontSizeFigma().sp),
                        decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            prefixIcon: (withPrefix)
                                ? Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: getSvgImage(context, imgName,
                                        getEditIconSizeFigma()),
                                  )
                                : getHorSpace(0),
                            border: InputBorder.none,
                            isDense: true,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: s,
                            hintStyle: TextStyle(
                                fontFamily: Constant.fontsFamily,
                                color: getFontHint(context),
                                fontWeight: FontWeight.w500,
                                fontSize: getEditFontSizeFigma().sp)),
                      )
                    : Center(
                        child: TextField(
                        maxLines: (minLines) ? null : 1,
                        controller: textEditingController,
                        autofocus: false,
                        focusNode: myFocusNode,
                        textAlign: TextAlign.start,
                        expands: minLines,
                        style: TextStyle(
                            fontFamily: Constant.fontsFamily,
                            color: fontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: getEditFontSizeFigma().sp),
                        decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            prefixIcon: (withPrefix)
                                ? Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: getSvgImage(context, imgName,
                                        getEditIconSizeFigma()),
                                  )
                                : getHorSpace(0),
                            border: InputBorder.none,
                            isDense: true,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: s,
                            hintStyle: TextStyle(
                                fontFamily: Constant.fontsFamily,
                                color: getFontHint(context),
                                fontWeight: FontWeight.w500,
                                fontSize: getEditFontSizeFigma().sp)),
                      )),
              ),
            )),
      );
    },
  );
}

Widget getDefaultCountryPickerTextFiled(BuildContext context, String s,
    TextEditingController textEditingController, Color fontColor,
    {bool withPrefix = false,
    String imgName = "",
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero}) {
  double height = getEditHeightFigma();
  return StatefulBuilder(
    builder: (context, setState) {

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 0),
        child: Container(
          height: (minLines) ? (height * 2.2) : height,
          margin: margin,
          alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
     decoration: BoxDecoration(
         border: Border(
           bottom: BorderSide(

               width: 0.5
           ),
     ),
     ),
          child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CountryCodePicker(
                    onChanged: print,
                    initialSelection: 'TN',
                    flagWidth: 24.w,
                    padding: EdgeInsets.zero,
                    textStyle: TextStyle(
                        fontFamily: Constant.fontsFamily,
                        color: fontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: getEditFontSizeFigma().sp),
                    favorite: const ['+216', 'TN'],
                    showCountryOnly: false,
                    showDropDownButton: true,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: (minLines) ? null : 1,
                      controller: textEditingController,
                      autofocus: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: Constant.fontsFamily,
                          color: fontColor,
                          fontWeight: FontWeight.w400,
                          fontSize: getEditFontSizeFigma().sp),
                      decoration: InputDecoration(
                          prefixIcon: (withPrefix)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 3.w),
                                  child: getSvgImage(
                                      context, imgName, getEditIconSize()),
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                          border: InputBorder.none,
                          isDense: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: s,
                          prefixIconConstraints:
                              const BoxConstraints(minHeight: 0, minWidth: 0),
                          hintStyle: TextStyle(
                              fontFamily: Constant.fontsFamily,
                              color: getFontHint(context),
                              fontWeight: FontWeight.w400,
                              fontSize: getEditFontSizeFigma().sp)),
                    ),
                    flex: 1,
                  )
                ],
              ),
        ),
      );
    },
  );
}

getProgressDialog() {
  return Container(
      color: Colors.transparent,
      child: Center(
          child: Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      const CupertinoThemeData(brightness: Brightness.dark)),
              child: const CupertinoActivityIndicator())));
}

Widget getPassTextFiled(
    BuildContext context,
    String s,
    TextEditingController textEditingController,
    Color fontColor,
    bool showPass,
    Function function,
    {bool withPrefix = false,
    String imgName = "",
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero}) {
  double height = getEditHeightFigma();
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        height: (minLines) ? (height * 2.2) : height,
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
        ),
        alignment: (minLines) ? Alignment.topLeft : Alignment.centerLeft,
        child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: (minLines) ? null : 1,
                  obscureText: (showPass) ? false : true,
                  controller: textEditingController,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: Constant.fontsFamily,
                      color: fontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: getEditFontSizeFigma().sp),
                  decoration: InputDecoration(
                      prefixIcon: (withPrefix)
                          ? Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: getSvgImage(
                                  context, imgName, getEditIconSize()),
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      isDense: true,
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: getAccentColor(context))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: getAccentColor(context))),
                      hintText: s,
                      prefixIconConstraints:
                          const BoxConstraints(minHeight: 0, minWidth: 0),
                      hintStyle: TextStyle(
                          fontFamily: Constant.fontsFamily,
                          color: getFontHint(context),
                          fontWeight: FontWeight.w400,
                          fontSize: getEditFontSizeFigma().sp)),
                ),
                flex: 1,
              ),
            ],
          ),
      );
    },
  );
}

Widget getPaddingWidget(EdgeInsets edgeInsets, Widget widget) {
  return Padding(
    padding: edgeInsets,
    child: widget,
  );
}

AppBar getInVisibleAppBar({Color color = Colors.transparent}) {
  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: color,
  );
}

Widget getRowWidget(
    BuildContext context, String title, String icon, Function function) {
  double iconSize = 24.h;
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      height: 60.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: FetchPixels.getDefaultHorSpaceFigma(context),
          vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 21.w),
      decoration: getButtonDecoration(Colors.white,
          withCorners: true,
          corner: getButtonCornersFigma(),
          shadow: [
            const BoxShadow(
                color: Color.fromRGBO(155, 103, 103, 0.10999999940395355),
                offset: Offset(-5, 6),
                blurRadius: 28)
          ]),
      child: Row(
        children: [
          getSvgImageWithSize(
            context,
            icon,
            iconSize,
            iconSize,
          ),
          getHorSpace(17.w),
          Expanded(
            child: getCustomFont(title, 16, getFontColor(context), 1,
                fontWeight: FontWeight.w500),
            flex: 1,
          ),
          getSvgImageWithSize(
            context,
            "arrow_right.svg",
            iconSize,
            iconSize,
          ),
        ],
      ),
    ),
  );
}

Widget getButtonFigma(
    BuildContext context,
    Color bgColor,
    bool withCorners,
    String text,
    Color textColor,
    Function function,
    EdgeInsetsGeometry insetsGeometry,
    {isBorder = false,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.w600,
    bool isIcon = false,
    String? icons,
    List<BoxShadow> shadow = const [],
    bool withGradient = false}) {
  double buttonHeight = getButtonHeightFigma();
  double fontSize = getButtonFontSizeFigma();
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      width: double.infinity,
      height: buttonHeight,
      decoration: (withGradient)
          ? getButtonDecorationWithGradient(bgColor,
              withCorners: withCorners,
              corner: (withCorners) ? getButtonCornersFigma() : 0,
              withBorder: isBorder,
              borderColor: borderColor,
              shadow: shadow)
          : getButtonDecoration(bgColor,
              withCorners: withCorners,
              corner: (withCorners) ? getButtonCornersFigma() : 0,
              withBorder: isBorder,
              borderColor: borderColor,
              shadow: shadow),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isIcon)
              ? getSvgImage(context, icons ?? "", getEditIconSizeFigma())
              : getHorSpace(0),
          (isIcon) ? getHorSpace(10.w) : getHorSpace(0),
          getCustomFont(
            text,
            fontSize,
            Colors.black,
            1,
            textAlign: TextAlign.center,
            fontWeight: weight,
          )
        ],
      ),
    ),
  );
}

Widget getButtonWithEndIcon(
    BuildContext context,
    Color bgColor,
    bool withCorners,
    String text,
    Color textColor,
    Function function,
    EdgeInsetsGeometry insetsGeometry,
    {isBorder = false,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.w600,
    bool isIcon = false,
    String? icons,
    List<BoxShadow> shadow = const []}) {
  double buttonHeight = getButtonHeight();
  double fontSize = getButtonFontSizeFigma();
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      width: double.infinity,
      height: buttonHeight,
      decoration: getButtonDecoration(bgColor,
          withCorners: withCorners,
          corner: (withCorners) ? getButtonCorners() : 0,
          withBorder: isBorder,
          borderColor: borderColor,
          shadow: shadow),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getHorSpace(10.w),
          Expanded(
            child: getCustomFont(
              text,
              fontSize,
              textColor,
              1,
              textAlign: TextAlign.start,
              fontWeight: weight,
            ),
            flex: 1,
          ),
          (isIcon)
              ? getSvgImage(context, icons ?? "", getEditIconSize())
              : getHorSpace(0),
          getHorSpace(10.w)
        ],
      ),
    ),
  );
}

Widget getSubButton(
    BuildContext context,
    Color bgColor,
    bool withCorners,
    String text,
    Color textColor,
    Function function,
    EdgeInsetsGeometry insetsGeometry,
    {isBorder = false,
    double width = double.infinity,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.w600,
    bool isIcon = false,
    String? icons}) {
  double buttonHeight = 40.h;
  double buttonCorner = 20.h;
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      width: width,
      height: buttonHeight,
      decoration: getButtonDecoration(bgColor,
          withCorners: withCorners,
          corner: (withCorners) ? buttonCorner : 0,
          withBorder: isBorder,
          borderColor: borderColor),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isIcon)
              ? getSvgImage(context, icons ?? "", getEditIconSize())
              : getHorSpace(0),
          (isIcon) ? getHorSpace(10.w) : getHorSpace(0),
          // Text("wruiewru"),
          getCustomFont(
            text,
            16,
            textColor,
            1,
            textAlign: TextAlign.center,
            fontWeight: weight,
          )
        ],
      ),
    ),
  );
}

Widget getCircularImage(BuildContext context, double width, double height,
    double radius, String img,
    {BoxFit boxFit = BoxFit.contain, bool listen = true}) {
  return SizedBox(
    height: height,
    width: width,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: getAssetImage(context, img, width, height,
          boxFit: boxFit, listen: listen),
    ),
  );
}

Widget getVerSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

Widget getSearchFigmaWidget(
    BuildContext context,
    TextEditingController searchController,
    Function filterClick,
    ValueChanged<String> onChanged,
    {bool readOnly = false,
    bool showFilter = true,
    String hint = "Where do?"}) {
  double height = getEditHeightFigma();
  double iconSize = getEditIconSizeFigma().h;
  double fontSize = getEditFontSizeFigma();

  return Container(
    width: double.infinity,
    height: height,
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: getButtonDecoration(Colors.transparent,
                withCorners: true,
                corner: getEditRadiusSizeFigma(),
                withBorder: true,
                borderColor: getCurrentTheme(context).focusColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getSvgImageWithSize(context, "Search.svg", iconSize, iconSize,
                    fit: BoxFit.scaleDown, color: getFontGreyColor(context)),
                getHorSpace(12.w),
                Expanded(
                  child: IntrinsicHeight(
                    child: TextField(
                      readOnly: readOnly,
                      controller: searchController,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: hint,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: Constant.fontsFamily,
                              fontSize: fontSize.sp,
                              fontWeight: FontWeight.w500,
                              color: getFontHint(context))),
                      style: TextStyle(
                          fontFamily: Constant.fontsFamily,
                          fontSize: fontSize.sp,
                          fontWeight: FontWeight.w500,
                          color: getFontColor(context)),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  flex: 1,
                ),

              ],
            ),
          ),
          flex: 1,
        ),
        (showFilter) ? getHorSpace(8.w) : getHorSpace(0),
        (showFilter)
            ? InkWell(
                onTap: () {
                  filterClick();
                },
                child: Container(
                  decoration: getButtonDecoration(Colors.transparent,
                      withCorners: true,
                      corner: getEditRadiusSizeFigma(),
                      withBorder: true,
                      borderColor: getCurrentTheme(context).focusColor),
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  height: double.infinity,
                  child: Center(
                      child: getSvgImageWithSize(
                          context, "filter.svg", 24.h, 24.h,
                          fit: BoxFit.scaleDown)),
                ),
              )
            : getHorSpace(0)
      ],
    ),
  );
}

Widget getSearchMapFigmaWidget(
    BuildContext context,
    TextEditingController searchController,
    ValueChanged<String> onChanged,
    String hint,
    {bool readOnly = false}) {
  double height = 46.h;
  double fontSize = 14;

  return Container(
    width: double.infinity,
    height: height,
    child: Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: getButtonDecoration(getCardColor(context),
          withCorners: true,
          corner: getEditRadiusSizeFigma(),
          withBorder: true,
          borderColor: getCurrentTheme(context).focusColor),
      child: IntrinsicHeight(
        child: TextField(
          readOnly: readOnly,
          controller: searchController,
          onChanged: onChanged,
          decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              border: InputBorder.none,
              hintStyle: TextStyle(
                  fontFamily: Constant.fontsFamily,
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w500,
                  color: getFontHint(context))),
          style: TextStyle(
              fontFamily: Constant.fontsFamily,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w500,
              color: getFontColor(context)),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ),
    ),
  );
}

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}
