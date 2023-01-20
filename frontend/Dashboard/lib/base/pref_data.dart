import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.app.smartparking";
  static String accesstoken = prefName + "accesstoken";
  static String refreshtoken = prefName + "refreshtoken";
  static String email = prefName + "email";
  static String isLoggedIn = prefName + "isLoggedIn";


  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static Future<String> getAcessToken() async {
    SharedPreferences preferences = await getPrefInstance();
    String acess = preferences.getString(accesstoken) ?? "";
    return acess;
  }

  static setAcessToken(String token) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(accesstoken, token);
  }

  static setRefreshToken(String token) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(refreshtoken, token);
  }

  static setEmail(String useremail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(email, useremail);
  }

  static setLogIn(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLoggedIn, avail);
  }




  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }
}
