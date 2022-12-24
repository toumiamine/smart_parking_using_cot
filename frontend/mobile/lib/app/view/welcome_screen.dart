// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../base/color_data.dart';
// import '../../base/constant.dart';
// import '../../base/pref_data.dart';
// import '../../base/resizer/fetch_pixels.dart';
// import '../../base/widget_utils.dart';
// import '../routes/app_routes.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _SplashScreen();
//   }
// }
//
// class _SplashScreen extends State<SplashScreen> {
//   checkLogin() async {
//     bool isLogin = await PrefData.isLogIn();
//     bool isFirst = await PrefData.isIntroAvailable();
//     print("chkval===$isLogin===$isFirst");
//     Timer(
//       const Duration(seconds: 1),
//       () {
//         (isLogin)
//             ? Constant.sendToNext(context, Routes.homeScreenRoute)
//             : (isFirst)
//                 ? Constant.sendToNext(context, Routes.introRoute)
//                 : Constant.sendToNext(context, Routes.loginRoute);
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     checkLogin();
//
//     // PrefData.isLogIn().then((value) {
//     //   Timer(
//     //     const Duration(seconds: 1),
//     //     () {
//     //       (value)
//     //           ? Constant.sendToNext(context, Routes.homeScreenRoute)
//     //           : Constant.sendToNext(context, Routes.introRoute);
//     //     },
//     //   );
//     // });
//   }
//
//   void backClick() {
//     Constant.backToPrev(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // FetchPixels(context);
//     Constant.setupSize(context);
//
//     return WillPopScope(
//         child: Scaffold(
//           backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
//           body: SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//             child: buildColumn(context),
//           ),
//         ),
//         onWillPop: () async {
//           backClick();
//           return false;
//         });
//   }
//
//   Column buildColumn(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         getSvgImageWithSize(context, "Logo.svg", 154.h, 172.h,
//             fit: BoxFit.fill),
//       ],
//     );
//   }
// }
