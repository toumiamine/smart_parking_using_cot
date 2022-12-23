import 'dart:convert';

import 'package:flutter/material.dart';

import '../../base/pref_data.dart';

class DarkMode with ChangeNotifier {
  bool darkMode = false;
  List<String> assetList = [];

  DarkMode(BuildContext context) {
    PrefData.getISDarkMode().then((value) {
      darkMode = value;
      notifyListeners();
    });
     DefaultAssetBundle.of(context).loadString('AssetManifest.json').then((manifestJson) {
       final valsets= json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/imagesNight'));
        valsets.forEach((element) {
          assetList.add(element.toString().replaceAll("assets/imagesNight/",""));
        });
     });

  }


}
