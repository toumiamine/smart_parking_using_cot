import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/base/pref_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyProfileScreen();
  }
}

class ToggleEditController extends GetxController {
  var isEditEnable = false.obs;

  toggleEditOption() {
    isEditEnable.toggle();
  }
}

class _MyProfileScreen extends State<MyProfileScreen> {
  finish() {
    Constant.backToFinish(context);
  }
  final ToggleEditController controller = Get.put(ToggleEditController());
  TextEditingController nameCon = TextEditingController(text: PrefData.fullname);
  TextEditingController emailCon =
      TextEditingController(text: PrefData.email);
  TextEditingController numberCon =
      TextEditingController(text: "+216 " + PrefData.phonenumber);
  TextEditingController passCon = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);
    Future _fetch() async {
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? phone = prefs.getString(PrefData.phonenumber);
      numberCon.text = "+216 " + phone!;

      String? email = prefs.getString(PrefData.email);
      emailCon.text = email!;

      String? name = prefs.getString(PrefData.fullname);
      nameCon.text = name!;
    }
    return FutureBuilder(future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
                backgroundColor: Colors.blue);
          }
          else {
return  WillPopScope(
    child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getToolbarWidget(context, "My Profile", () {}),
          Expanded(
            child: ListView(
              padding: edgeInsets,
              shrinkWrap: true,
              primary: true,
              children: [
                getVerSpace(50.h),
                Obx(() => buildProfilePhotoWidget(context,
                    icons: controller.isEditEnable.isTrue
                        ? "edit_profile.svg"
                        : "ic_edit.svg", function: () {
                      if (controller.isEditEnable.isTrue) {}
                    })),
                getVerSpace(15.h),
                buildTextFieldWidget(context, nameCon),
                buildTextFieldWidget(context, emailCon),
                buildTextFieldWidget(context, numberCon),
                buildTextFieldWidget(context, passCon, isPass: true),
              ],
            ),
            flex: 1,
          ),
          getVerSpace(20.h),
          Obx(() => getButtonFigma(
              context,
              getAccentColor(context),
              true,
              (controller.isEditEnable.isTrue)
                  ? "Save"
                  : "Update Profile",
              Colors.black, () {
            controller.toggleEditOption();
          }, edgeInsets)),
          getVerSpace(40.h)
        ],
      ),
      // body: GetBuilder<ToggleEditController>(
      //   init: ToggleEditController(),
      //   builder: (controller) {
      //     return ;
      //   },
      // ),
    ),
    onWillPop: () async {
      finish();
      return false;
    });
          }
        }
    );

  }

  Widget buildTextFieldWidget(
      BuildContext context, TextEditingController _controller,
      {bool isPass = false}) {
    return Obx(() => getPaddingWidget(
        EdgeInsets.symmetric(vertical: 15.h),
        Column(
          children: [
            TextField(
              controller: _controller,
              enabled: controller.isEditEnable.isTrue,
              readOnly: controller.isEditEnable.isFalse,
              obscureText: isPass,
              style: buildTextStyle(
                  context, getFontColor(context), FontWeight.w500, 16),
              decoration: InputDecoration(
                  isDense: true,
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.h, color: dividerColor)),
                  hintStyle: buildTextStyle(
                      context, getFontColor(context), FontWeight.w500, 16),
                  contentPadding: EdgeInsets.only(bottom: 15.h),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1.h, color: getAccentColor(context))),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.h, color: dividerColor))),
            )
          ],
        )));
  }
}
