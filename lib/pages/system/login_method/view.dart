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
            // 头部标题
            PageTitleWidget(),

          // 手机号登录
          ButtonWidget.primary(
                LocaleKeys.loginMethodPhone.tr,
                onTap: () {
                  Get.toNamed(RouteNames.systemLogin);
                },
              )
              .width(double.infinity)
              .padding(
                left: AppSpace.card * 2,
                right: AppSpace.card * 2,
                top: AppSpace.card * 10,
              ),

          // 微信登录
          ButtonWidget.primary(
                LocaleKeys.loginMethodWx.tr,
                onTap: () {
                  // Get.toNamed(RouteNames.wxLogin);
                },
              )
              .width(double.infinity)
              .padding(
                left: AppSpace.card * 2,
                right: AppSpace.card * 2,
                top: AppSpace.card * 2,
              ),

          <Widget>[
                //  隐私政策
                IconWidget.icon(
                  controller.agreeUserProtocol
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  size: 20,
                  text: LocaleKeys.loginMethodAgree.tr,
                ).padding().onTap(() {
                  controller.onTapAgreeUserProtocol();
                }),

                //  用户协议 （添加下划线）
                TextWidget.muted(
                  LocaleKeys.loginMethodUserProtocol.tr,
                  textDecoration: TextDecoration.underline,
                ).paddingLeft(AppSpace.card).onTap(() {}),

                // 和
                TextWidget.muted(
                  LocaleKeys.loginMethodAnd.tr,
                ).paddingLeft(AppSpace.card).onTap(() {}),

                // 隐私政策 （添加下划线）
                TextWidget.muted(
                  LocaleKeys.loginMethodPrivacyPolicy.tr,
                  textDecoration: TextDecoration.underline,
                ).paddingLeft(AppSpace.card).onTap(() {}),
              ]
              .toRow(mainAxisAlignment: MainAxisAlignment.start)
              .padding(
                left: AppSpace.card * 2,
                right: AppSpace.card * 2,
                top: AppSpace.card * 2,
              ),
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
