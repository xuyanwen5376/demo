import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';

class MainController extends GetxController {
  MainController();

  // 分页管理
  final PageController pageController = PageController();

  // 当前的 tab index
  int currentIndex = 0;

  // 导航栏切换
  void onIndexChanged(int index) {
    currentIndex = index;
    update(['navigation']);
  }

  // 切换页面
  void onJumpToPage(int page) {
    // 下去键盘
    FocusScope.of(Get.context!).unfocus();
    pageController.jumpToPage(page);
  }

  // 退出请求时间
  DateTime? currentBackPressTime;

  // 返回键退出
  bool closeOnConfirm(BuildContext context) {
    DateTime now = DateTime.now();
    // 物理键，两次间隔大于4秒, 退出请求无效
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 4)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Center(child: Text('Press again to exit the application.')),
          duration: Duration(seconds: 4),
        ),
      );
      return false;
    }

    // 退出请求有效
    currentBackPressTime = null;
    return true;
  }

  /// 初始化数据
  _initData() async {
    // 读取用户 profile

    // IM 登录
    // IMService.to.login();

    update(["main"]);
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

    // 检查是否登录
    if (!UserService.to.hasToken) {
      Get.toNamed(RouteNames.systemLogin);
    }
  }

  @override
  void onClose() {
    super.onClose();
    // 释放页控制器
    pageController.dispose();
  }
}
