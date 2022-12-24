import 'package:flutter/material.dart';
import 'package:flutter_parking_ui_new/app/booking/extend_time_screen.dart';
import 'package:flutter_parking_ui_new/app/detail/chat_screen.dart';
import 'package:flutter_parking_ui_new/app/detail/gallery_screen.dart';
import 'package:flutter_parking_ui_new/app/detail/screen_location_detail.dart';
import 'package:flutter_parking_ui_new/app/detail/select_date_time_screen.dart';
import 'package:flutter_parking_ui_new/app/home/home_screen.dart';
import 'package:flutter_parking_ui_new/app/login/screen_change_pass.dart';
import 'package:flutter_parking_ui_new/app/login/screen_check_mail.dart';
import 'package:flutter_parking_ui_new/app/login/screen_forgot_pass.dart';
import 'package:flutter_parking_ui_new/app/login/screen_login.dart';
import 'package:flutter_parking_ui_new/app/login/screen_sign_up.dart';
import 'package:flutter_parking_ui_new/app/login/screen_verify.dart';
import 'package:flutter_parking_ui_new/app/profile/help_screen.dart';
import 'package:flutter_parking_ui_new/app/profile/my_profile_screen.dart';
import 'package:flutter_parking_ui_new/app/profile/setting_screen.dart';
import '../intro/intro.dart';
import '../view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) => const SplashScreen(),
    Routes.introRoute: (context) => const IntroView(),
    Routes.signUpRoute: (context) => const ScreenSignUp(),
    Routes.loginRoute: (context) => const ScreenLogin(),
    Routes.forgotPassRoute: (context) => const ScreenForgotPass(),
    Routes.checkMailScreenRoute: (context) => ScreenCheckMail(),
    Routes.verifyCodeRoute: (context) => const ScreenVerify(),
    Routes.changePassRoute: (context) => const ScreenChangePass(),
    Routes.homeScreenRoute: (context) => HomeScreen(),
    Routes.locationDetailScreenRoute: (context) => ScreenLocationDetail(),
    Routes.galleryScreenRoute: (context) => GalleryScreen(),
    Routes.dateTimeSelectorScreen: (context) => SelectDateTimeScreen(),
    Routes.extendTimeScreen: (context) => ExtendTimeScreen(),
    Routes.myProfileScreen: (context) => MyProfileScreen(),
    Routes.settingScreen: (context) => SettingScreen(),
    Routes.helpScreen: (context) => HelpScreen(),
    Routes.chatScreen: (context) => ChatScreen(),
  };
}
