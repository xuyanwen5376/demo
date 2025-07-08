import 'package:get/get.dart';

class AppbarController extends GetxController {
  AppbarController();

  _initData() {
    update(["appbar"]);
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
