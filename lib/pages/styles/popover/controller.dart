import 'package:get/get.dart';

class PopoverController extends GetxController {
  PopoverController();

  _initData() {
    update(["popover"]);
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
