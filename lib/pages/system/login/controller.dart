import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../common/index.dart';

class LoginController extends GetxController {
  LoginController();

  /// 用户名
  TextEditingController userNameController = TextEditingController(
    text: "ducafecat5",
  );

  /// 密码
  TextEditingController passwordController = TextEditingController(
    text: "123456",
  );

  /// 表单 key
  GlobalKey formKey = GlobalKey<FormState>();

  _initData() {
    update(["login"]);
  }

  /// Sign In
  Future<void> onSignIn() async {
    if ((formKey.currentState as FormState).validate()) {
      try {
        Loading.show();

        // aes 加密密码
        var password = EncryptUtil().aesEncode(passwordController.text);

        // api 请求
        UserTokenModel res = await UserApi.login(
          UserLoginReq(username: userNameController.text, password: password),
        );

        // 本地保存 token
        await UserService.to.setToken(res.token!);

        // 获取用户资料
        await UserService.to.getProfile();

        // 检查用户资料是否完整
        final profile = UserService.to.profile;
        profile.imSign = 'eJwtzE8LgjAcxvH3snPoZs5NoYNQUdHNCAwv6mb8aP5BrZzRe2*px*fzheeDLufIeskWBcixMFpNG4SseihgYvHM00LmaU*X2olH2jQgUEA8jLHvcr6eixwaaKVxSqlj0qw9lH9jlLiOz5m-vMDdnOusS*xyvCV2HI2HvapEGwt2Ve84rMHTxUBUWO-0aUu6Y7hB3x-i*TTm';
        if (profile.username == null || profile.imSign == null) {
          Loading.error('User profile incomplete. Please contact support.');
          return;
        }

        // IM 登录
        IMService.to.login();

        Loading.success();
        Get.back(result: true);
      } finally {
        Loading.dismiss();
      }
    }
  }

  /// Sign Up 注册
  void onSignUp() {
    Get.offNamed(RouteNames.systemRegister);
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

  /// 释放
  @override
  void onClose() {
    super.onClose();
    userNameController.dispose();
    passwordController.dispose();
  }
}
