import 'package:get/get.dart';

class RadioGroupController extends GetxController {
  RadioGroupController();

  _initData() {
    update(["radio_group"]);
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
