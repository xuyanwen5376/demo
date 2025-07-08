import 'package:get/get.dart';

class AvatarController extends GetxController {
  AvatarController();

  _initData() {
    update(["avatar"]);
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
