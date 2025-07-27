import 'package:get/get.dart';

class LoginMethodController extends GetxController {
  LoginMethodController();

  _initData() {
    update(["login_method"]);
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
