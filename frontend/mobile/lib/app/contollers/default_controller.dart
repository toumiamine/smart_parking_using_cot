import 'package:get/get.dart';

class DefaultController extends GetxController {
  RxInt selectedIndex = 0.obs;
  int chooseVehicle = 0;

  chooseVehicles(int pos) {
    chooseVehicle = pos;
    update();
  }

  changePosition(int i) {
    selectedIndex(i);
  }
}
