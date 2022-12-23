import 'package:get/get.dart';

class HomeFilterController extends GetxController {
  final List<String> sortList = ["Distance", "Slots Available"];
 String selectedSort = "Distance";
 double progress =10.0;

  void onClickRadioButton(String value) {
    // print(value);
    selectedSort = value;
    update();

  }
  void changeProgress(double value) {
    // print(value);
    progress = value;
    update();

  }
}
