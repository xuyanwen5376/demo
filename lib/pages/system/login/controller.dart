import 'dart:async';

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

  // 手机号
  TextEditingController phoneController = TextEditingController(
    text: "13800138000",
  );

  /// 验证码
  TextEditingController codeController = TextEditingController(text: "123456");

  /// 表单 key
  GlobalKey formKey = GlobalKey<FormState>();

  /// 同意用户协议
  bool agreeUserProtocol = false;

  /// 倒计时秒数
  int countdown = 0;

  /// 是否已发送过验证码
  bool hasSentCode = false;

  /// 倒计时定时器
  Timer? _timer;

  _initData() {
    update(["login"]);
  }

  /// 发送验证码
  void onSendVerificationCode() {
    if (countdown > 0) return; // 倒计时中不允许再次发送

    print("发送验证码");

    // 标记为已发送过验证码
    hasSentCode = true;

    // 开始倒计时 60s
    countdown = 60;
    update(["login"]);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown--;
      update(["login"]);
      if (countdown <= 0) {
        // 倒计时结束 取消定时器 文字变成 重新发送
        _timer?.cancel();
        _timer = null;
        update(["login"]);
      }
    });
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
        profile.imSign =
            'eJwtzE8LgjAcxvH3snPoZs5NoYNQUdHNCAwv6mb8aP5BrZzRe2*px*fzheeDLufIeskWBcixMFpNG4SseihgYvHM00LmaU*X2olH2jQgUEA8jLHvcr6eixwaaKVxSqlj0qw9lH9jlLiOz5m-vMDdnOusS*xyvCV2HI2HvapEGwt2Ve84rMHTxUBUWO-0aUu6Y7hB3x-i*TTm';
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

  /// 同意用户协议
  void onTapAgreeUserProtocol() {
    agreeUserProtocol = !agreeUserProtocol;
    update(["login"]);
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
    _timer?.cancel();
  }
}
