import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    Key? key,
    this.controller,
    this.itemCount,
    this.selectedPos,
    this.onPageSelected,
    this.selectedColor = Colors.black,
    this.color = Colors.white,
  }) : super(key: key, listenable: controller!);

  final PageController? controller;

  final int? itemCount;
  final int? selectedPos;

  final ValueChanged<int>? onPageSelected;

  final Color color;
  final Color selectedColor;

  Widget _buildDot(int index) {
    return SizedBox(
      width: 20.h,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(3.h)),
          color: (selectedPos == index) ? selectedColor : color,
          // type: MaterialType.circle,
          child: SizedBox(
            width: (selectedPos == index) ? 19.h : 7.h,
            height: 7.h,
            child: InkWell(
              onTap: () => onPageSelected!(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount!, _buildDot),
    );
  }
}
