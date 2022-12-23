import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/home/tabs/tab_location.dart';
import 'package:flutter_parking_ui_new/app/home/tabs/tab_my_booking.dart';
import 'package:flutter_parking_ui_new/app/home/tabs/tab_profile.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  List<String> imgList = ["ticket", "", "user"];

  List<Widget> tabList = [
    TabMyBooking(),
    TabLocation(),
    TabProfile(),
   // Container(width: double.infinity, height: double.infinity,)
  ];

  finish() {
    Constant.closeApp();
  }

  int selectedVal = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        finish();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
        body: tabList[selectedVal],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //specify the location of the FAB
        floatingActionButton: InkWell(
          onTap: () {
            setState(() {
              selectedVal = 1;
            });
          },
          child: Container(

            width: 54.h,
            height: 54.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getAccentColor(context),
            ),
            child: Center(
               child: getSvgImageWithSize(context, "location_button.svg", 24.h, 24.h),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10.h,
          elevation: 7.h,
          child: Container(
            color: Colors.transparent,
            height: 100.h,
            // margin: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(imgList.length, (index) {
                  return Expanded(
                    child: (imgList[index].isEmpty)
                        ? SizedBox(
                      width: 0,
                    )
                        : Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedVal = index;
                          });
                        },
                        child: getSvgImageWithSize(
                            context,
                            "${(selectedVal == index)
                                ? "${imgList[index]}_selected"
                                : imgList[index]}.svg",
                            24.h,
                            24.h),
                      ),
                    ),
                    flex: 1,
                  );
                })
              // <Widget>[
              //   IconButton(
              //     //update the bottom app bar view each time an item is clicked
              //     onPressed: () {
              //       updateTabSelection(0, "Home");
              //     },
              //     iconSize: 27.0,
              //     icon: Icon(
              //       Icons.home,
              //       //darken the icon if it is selected or else give it a different color
              //       color: selectedIndex == 0
              //           ? Colors.blue.shade900
              //           : Colors.grey.shade400,
              //     ),
              //   ),
              //   IconButton(
              //     onPressed: () {
              //       updateTabSelection(1, "Outgoing");
              //     },
              //     iconSize: 27.0,
              //     icon: Icon(
              //       Icons.call_made,
              //       color: selectedIndex == 1
              //           ? Colors.blue.shade900
              //           : Colors.grey.shade400,
              //     ),
              //   ),
              //   //to leave space in between the bottom app bar items and below the FAB
              //   SizedBox(
              //     width: 50.0,
              //   ),
              //   IconButton(
              //     onPressed: () {
              //       updateTabSelection(2, "Incoming");
              //     },
              //     iconSize: 27.0,
              //     icon: Icon(
              //       Icons.call_received,
              //       color: selectedIndex == 2
              //           ? Colors.blue.shade900
              //           : Colors.grey.shade400,
              //     ),
              //   ),
              //   IconButton(
              //     onPressed: () {
              //       updateTabSelection(3, "Settings");
              //     },
              //     iconSize: 27.0,
              //     icon: Icon(
              //       Icons.settings,
              //       color: selectedIndex == 3
              //           ? Colors.blue.shade900
              //           : Colors.grey.shade400,
              //     ),
              //   ),

            ),
          ),
          //to add a space between the FAB and BottomAppBar
          shape: CircularNotchedRectangle(),
          //color of the BottomAppBar
          color: getCurrentTheme(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
