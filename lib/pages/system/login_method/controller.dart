import 'package:get/get.dart';

class LoginMethodController extends GetxController {
  LoginMethodController();

  // 同意 用户协议
  bool agreeUserProtocol = false;

  _initData() {
    update(["login_method"]);
  }


// 点击同意 用户协议
  void onTapAgreeUserProtocol() {
    agreeUserProtocol = !agreeUserProtocol;
    update(["login_method"]);
  }

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
