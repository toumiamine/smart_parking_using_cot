import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/size_config.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant.dart';
import 'model_review_slider.dart';

typedef OnChange = void Function(int index);

class ReviewSlider extends StatefulWidget {
  const ReviewSlider(
      {Key? key,
      @required this.onChange,
      this.initialValue,
      this.options = const [],
      this.optionStyle,
      this.width,
      this.isCash,
      this.circleDiameter = 30})
      : super(key: key);

  /// The onChange callback calls every time when a pointer have changed
  /// the value of the slider and is no longer in contact with the screen.
  /// Callback function argument is an int number from 0 to 4, where
  /// 0 is the worst review value and 4 is the best review value

  /// ```dart
  /// ReviewSlider(
  ///  onChange: (int value){
  ///    print(value);
  ///  }),
  /// ),
  /// ```

  final OnChange? onChange;
  final int? initialValue;
  final List<ModelReviewSlider>? options;
  final TextStyle? optionStyle;
  final double? width;
  final double? circleDiameter;
  final bool? isCash;

  @override
  _ReviewSliderState createState() => _ReviewSliderState();
}

class _ReviewSliderState extends State<ReviewSlider>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  double initValue = 0;

  @override
  void initState() {
    super.initState();

    initValue = widget.initialValue!.toDouble();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    widget.onChange!(widget.initialValue!);
  }

  void handleTap(int state) {
    widget.onChange!(state);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      children: <Widget>[
        MeasureLine(
          states: widget.options!,
          handleTap: handleTap,
          animationValue: initValue,
          width: Constant.getWidthPercentSize(80),
          options: widget.options!,
          isCash: widget.isCash!,
          oValue: widget.initialValue,
          optionStyle: widget.optionStyle!,
          circleDiameter: widget.circleDiameter!,
        ),
      ],
    );
  }
}

const double paddingSize = 10;

class MeasureLine extends StatelessWidget {
  const MeasureLine(
      {Key? key,
      this.handleTap,
      this.animationValue,
      this.states,
      this.width,
      this.isCash,
      this.initValue,
      this.options,
      this.oValue,
      this.optionStyle,
      this.circleDiameter})
      : super(key: key);

  final double? animationValue;
  final Function? handleTap;
  final List<ModelReviewSlider>? options;

  final bool? isCash;
  final int? oValue;
  final int? initValue;
  final List<ModelReviewSlider>? states;
  final double? width;
  final TextStyle? optionStyle;
  final double? circleDiameter;

  List<Widget> _buildUnits(BuildContext context) {
    // double size = Constant.getPercentSize(circleDiameter!, 55);
    double size = 24.h;

    var res = <Widget>[];

    states!.asMap().forEach((index, text) {
      res.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ((index <= oValue!))
              ? Container(
                  height: 44.h,
                  width: 44.h,
                  // width: size,
                  decoration: BoxDecoration(
                    color: "#FFF3F3".toColor(),
                    shape: BoxShape.circle,
                  ),
                  // child: getSvgImage(text.image ?? "", size),
                  child: Center(
                      child: getSvgImageWithSize(
                          context, text.image ?? "", size, size,
                          color: getAccentColor(context))),
                  // child: Center(child: getSvgImageWithSize(context,"checkout_tick.svg", size,size,color: getAccentColor(context))),
                )
              : Container(
                  height: 44.h,
                  width: 44.h,
                  decoration: BoxDecoration(
                    color: "#F9F9F9".toColor(),
                    shape: BoxShape.circle,
                  ),
                  // height: size,
                  // width: size,
                  child: Center(
                    child: getSvgImageWithSize(
                        context, text.image ?? "", size, size,
                        color: greyFont),
                  )),
          // SizedBox(
          //   height: Constant.getPercentSize(circleDiameter!, 15),
          // ),
          // Text(
          //   text.title ?? "",
          //   style: TextStyle(
          //       color: (index <= oValue!) ? getFontColor(context) : greyFont,
          //       fontFamily: Constant.fontsFamily,
          //       fontSize: Constant.getHeightPercentSize(2.4),
          //       fontWeight: FontWeight.w500),
          // )
        ],
      ));
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: 22.h,
              left: FetchPixels.getDefaultHorSpaceFigma(context),
              right: FetchPixels.getDefaultHorSpaceFigma(context)),
          child: Row(
            children: [
              getLine(0),
              getLine(1),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildUnits(
              context,
            ),
          ),
        ),
      ],
    );
  }

  getLine(int i) {
    return Expanded(
      child: SizedBox(
        child: DottedLine(
          direction: Axis.horizontal,
          lineLength: double.infinity,
          lineThickness: 1.2,
          dashLength: 2.0,
          dashColor: (i < oValue!) ? primaryColor : greyFont,
          dashRadius: 0.0,
          dashGapLength: 2.0,
          dashGapColor: Colors.transparent,
          dashGapRadius: 0.0,
        ),
        height: 1.2,
      ),
    );
  }
}
