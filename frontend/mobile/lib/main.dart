import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_pages.dart';
import 'base/color_data.dart';
import 'base/my_custom_scroll_behavior.dart';
import 'app/notifier/dark_mode.dart';
import 'base/restart_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(RestartController(
    child: ChangeNotifierProvider(
        create: (context) => DarkMode(context), child: const MyApp()),
  ));
}


class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var darkThemeProvider = Provider.of<DarkMode>(context);
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Grocery',
      initialRoute:AppPages.initialRoute,
      theme: getLightThemeData(),
      darkTheme: getDarkThemeData(),
      themeMode: (darkThemeProvider.darkMode) ? ThemeMode.dark : ThemeMode.light,
      routes: AppPages.routes,
    );
  }
}

