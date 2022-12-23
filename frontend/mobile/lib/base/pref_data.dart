import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.app.smartparking";
  static String introAvailable = prefName + "isIntroAvailable";
  static String isLoggedIn = prefName + "isLoggedIn";
  static String getTheme = prefName + "isSelectedTheme";
  static String fullname = prefName + "fullname";
  static String email = prefName + "email";
  static String phonenumber = prefName + "phonenumber";


  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static Future<bool> isIntroAvailable() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(introAvailable) ?? true;
    return isIntroAvailable;
  }

  static setIntroAvailable(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(introAvailable, avail);
  }

  static setLogIn(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLoggedIn, avail);
  }

  static setFullName(String name) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(fullname, name);
  }

  static setEmail(String email_) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(email, email_);
  }

  static setPhoneNumber(String phonenum) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(phonenumber, phonenum);
  }


  static setDarkMode(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(getTheme, avail);
  }

  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }





  static Future<bool> getISDarkMode() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(getTheme) ?? false;
    return isIntroAvailable;
  }
}
