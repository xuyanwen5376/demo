import 'package:get/get.dart';

class PersontestController extends GetxController {
  PersontestController();

  _initData() {
    update(["persontest"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
