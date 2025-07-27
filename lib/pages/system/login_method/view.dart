import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';

class LoginMethodPage extends GetView<LoginMethodController> {
  const LoginMethodPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
          // 登录方式
          Container(
            width: double.infinity,
            child: <Widget>[
                  ImageWidget.img(
                    "https://ducafecat-pub.oss-cn-qingdao.aliyuncs.com/avatar/00258VC3ly1gty0r05zh2j60ut0u0tce02.jpg",
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                  ),
                  TextWidget.label(LocaleKeys.appName.tr),
                ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.center)
                .paddingAll(AppSpace.card),
          ),

          // 手机号登录
          ButtonWidget.primary(
            LocaleKeys.loginMethodPhone.tr,
            onTap: () {
              Get.toNamed(RouteNames.systemLogin);
            },
          ).width(double.infinity).padding(left: AppSpace.card*2, right: AppSpace.card*2, top: AppSpace.card*10),

          // 微信登录
          ButtonWidget.primary(
            LocaleKeys.loginMethodWx.tr,
            onTap: () {
              // Get.toNamed(RouteNames.wxLogin);
            },
          ).width(double.infinity).padding(left: AppSpace.card*2, right: AppSpace.card*2, top: AppSpace.card*2),

          //  隐私政策
          IconWidget.icon(
            Icons.select_all_outlined,
            size: 20,
            text: '我已阅读并同意 用户协议  和 隐私政策',
          ).padding(left: AppSpace.card*2, right: AppSpace.card*2, top: AppSpace.card*2).onTap(() {}),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(AppSpace.card);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginMethodController>(
      init: LoginMethodController(),
      id: "login_method",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
