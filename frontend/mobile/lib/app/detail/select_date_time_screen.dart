import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/detail/choose_parking_slot_screen.dart';
import 'package:flutter_parking_ui_new/app/routes/app_routes.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter_parking_ui_new/base/slider.dart' as sliders;
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateTimeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectDateTimeScreen();
  }
}

class _SelectDateTimeScreen extends State<SelectDateTimeScreen> {
  finish() {
    Constant.backToFinish(context);
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _selected_numer_hours;
  String? _selectedTime;
  ValueNotifier<double> _progressVal = ValueNotifier(1);



  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          // appBar: getInVisibleAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getToolbarWidget(context, "Date & Time", () {}),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    getVerSpace(30.h),
                    getPaddingWidget(
                        edgeInsets,
                        getCustomFont("Reserve a parking slot", 16,
                            getFontColor(context), 1,
                            fontWeight: FontWeight.w600)),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: horSpace, vertical: 12.h),
                      padding: EdgeInsets.only(bottom: 9.h),
                      width: double.infinity,
                      // height: 329.h,
                      decoration: getButtonDecoration(getCardColor(context),
                          shadow: [
                            BoxShadow(
                                color: Color.fromRGBO(232, 232, 232, 1),
                                offset: Offset(0, 13),
                                blurRadius: 24)
                          ],
                          withCorners: true,
                          corner: 8.h),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(Duration(days: 365)),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        headerStyle: HeaderStyle(
                            // formatButtonShowsNext: false,
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: getSvgImageWithSize(
                                context, "iconPrev.svg", 32.h, 32.h),
                            rightChevronIcon: getSvgImageWithSize(
                                context, "iconNext.svg", 32.h, 32.h),
                            titleTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w700, 20)),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekendStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            weekdayStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13)),
                        calendarStyle: CalendarStyle(
                            defaultTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            holidayTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            disabledTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            selectedTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            weekendTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            outsideTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13),
                            cellMargin: EdgeInsets.symmetric(horizontal: 10.w),
                            cellPadding: EdgeInsets.zero,
                            cellAlignment: Alignment.center,
                            selectedDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              // borderRadius: BorderRadius.all(Radius.circular(8.h)),
                              // border: Border.all(
                              //     color: getFontColor(context), width: 1.h),
                              color: getAccentColor(context),
                              // border: Border.all(color: getFontColor(context),width: 1.h),
                              borderRadius: BorderRadius.circular(5.h),
                            ),
                            disabledDecoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            outsideDecoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            weekendDecoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            holidayDecoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            defaultDecoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            todayDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                // color: greenColor,
                                border: Border.all(
                                    color: getFontColor(context), width: 1.h),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.h))),
                            isTodayHighlighted: true,
                            todayTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 13)),
                        // daysOfWeekHeight: ,
                        rowHeight: 37.h,
                        selectedDayPredicate: (day) {
                          // Use `selectedDayPredicate` to determine which day is currently selected.
                          // If this returns true, then `day` will be marked as selected.

                          // Using `isSameDay` is recommended to disregard
                          // the time-part of compared DateTime objects.
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            // Call `setState()` when updating the selected day
                            setState(() {
                              _selectedDay = selectedDay;
                              String convertedDate = new DateFormat("yyyy-MM-dd").format(selectedDay);
                              print(convertedDate);
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            // Call `setState()` when updating calendar format
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          // No need to call `setState()` here
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    getPaddingWidget(
                        edgeInsets,
                        getCustomFont(
                            "Pick a time", 16, getFontColor(context), 1,
                            fontWeight: FontWeight.w600)),
                    getVerSpace(30.h),
                    ValueListenableBuilder(
                      builder: (context, value, child) {
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              showValueIndicator:
                                  ShowValueIndicator.onlyForContinuous,
                              // valueIndicatorShape: SliderComponentShape.noOverlay
                              valueIndicatorColor: Colors.transparent,
                              valueIndicatorTextStyle: buildTextStyle(
                                  context,
                                  getFontColor(context),
                                  FontWeight.w500,
                                  16)
                              ),
                          child: sliders.Slider(
                            label: "${_progressVal.value.toInt()} hour",
                            thumbColor: getAccentColor(context),
                            activeColor: getAccentColor(context),
                            inactiveColor: getCurrentTheme(context).focusColor,
                            onChanged: (value) {
                              _progressVal.value = value;
                            //  print(_progressVal.value.toInt());
                            },
                            value: _progressVal.value,
                            max: 10,
                            min: 1,
                          ),
                        );
                      },
                      valueListenable: _progressVal,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: horSpace, vertical: 12.h),
                      decoration: getButtonDecoration(getCardColor(context),
                          shadow: [
                            BoxShadow(
                                color: Color.fromRGBO(232, 232, 232, 1),
                                offset: Offset(0, 13),
                                blurRadius: 24)
                          ],
                          withCorners: true,
                          corner: 8.h),
                      child: Column(
                        children: [
                          TimePickerSpinner(
                            // itemHeight: ,
                            spacing: 24.w,
                            itemHeight: 56.h,
                            itemWidth: 60.h,
                            isShowSeconds: false,
                            highlightedTextStyle: buildTextStyle(context,
                                getFontColor(context), FontWeight.w500, 20),
                            normalTextStyle: buildTextStyle(context,
                                getFontGreyColor(context), FontWeight.w500, 20),
                            isForce2Digits: true,
                            is24HourMode: false,
                            minutesInterval: 1,
                            onTimeChange: (time) {
                              setState(() {
                               _selectedTime = DateFormat.Hm().format(time);
                              });
                            },
                          ),
                          getVerSpace(10.h),
                         /* getPaddingWidget(
                              EdgeInsets.symmetric(horizontal: 45.w),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120.w,
                                    height: 40.h,
                                    decoration: getButtonDecoration(
                                        Colors.transparent,
                                        withCorners: true,
                                        corner: 20.h,
                                        withBorder: true,
                                        borderColor: getFontColor(context)),
                                    child: Center(
                                      child: getCustomFont("Cancel", 14,
                                          getFontColor(context), 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  getHorSpace(10.w),
                                  Container(
                                    width: 120.w,
                                    height: 40.h,
                                    decoration: getButtonDecoration(
                                        getAccentColor(context),
                                        withCorners: true,
                                        corner: 20.h,
                                        withBorder: true),
                                    child: Center(
                                      child: getCustomFont(
                                          "Save", 14, Colors.black, 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              )),*/
                          getVerSpace(20.h),
                        ],
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
              getVerSpace(2.h),
              getButtonFigma(context, getAccentColor(context), true, "Confirm",
                  getFontColor(context), () {
                if (_selectedDay != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseParkingSlotScreen(selected_date: DateFormat("yyyy-MM-dd").format(_selectedDay!), selected_time: _selectedTime!, number_hours: _progressVal.value.toInt())),
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a date", style: TextStyle(color: Colors.white),)
                        , backgroundColor: Colors.red,
                      )
                  );
                }

              }, EdgeInsets.symmetric(horizontal: horSpace, vertical: 16.h))
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
