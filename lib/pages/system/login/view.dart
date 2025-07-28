import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/index.dart';
import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  // 表单页
  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget>[
        // 手机号码
        InputFormFieldWidget(
          controller: controller.phoneController,
          labelText: LocaleKeys.loginPhoneNumber.tr,
          // tipText: "输入手机号码",
          placeholder: "请输入手机号码",
          prefix: const Icon(Icons.phone),
          // suffix: const Icon(Icons.done),
          validator: Validatorless.multiple([
            Validatorless.required(LocaleKeys.validatorRequired.tr),
            Validatorless.min(
              3,
              LocaleKeys.validatorMin.trParams({"size": "3"}),
            ),
            Validatorless.max(
              20,
              LocaleKeys.validatorMax.trParams({"size": "20"}),
            ),
          ]),
        ).paddingBottom(AppSpace.listRow.w),

        // 验证码 和 发送验证码
        <Widget>[
          // 验证码
          InputFormFieldWidget(
            controller: controller.codeController,
            labelText: LocaleKeys.loginVerificationCode.tr,
            placeholder: "请输入验证码",
            // tipText: "请输入验证码",
            prefix: const Icon(Icons.sms),
            suffix: const Icon(Icons.remove_red_eye),
            validator: Validatorless.multiple([
              Validatorless.required(LocaleKeys.validatorRequired.tr),
            ]),
          ).expanded(),

          // 间隔
          SizedBox(width: 10.w),

          // 发送验证码 - 使用Container包装并设置对齐方式
          Container(
            height: 55, // 设置一个固定高度，与输入框保持一致
            alignment: Alignment.center,
            child: ButtonWidget.primary(
              // 根据倒计时状态显示不同文本
              controller.countdown > 0
                  ? "${controller.countdown}秒"
                  : controller.hasSentCode
                  ? "重新发送"
                  : LocaleKeys.loginVerificationCodeSend.tr,
              onTap: controller.onSendVerificationCode,
              // 倒计时期间禁用按钮
              enabled: controller.countdown <= 0,
            ).tight(width: 100.w),
          ),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.end),

        // 登录按钮
        ButtonWidget.primary(
          LocaleKeys.loginSignIn.tr,
          onTap: controller.onSignIn,
        ).width(double.infinity).paddingBottom(30.w).paddingTop(20.w),
        // end
      ].toColumn().paddingVertical(10),
    ).paddingAll(AppSpace.card);
  }

  // 同意用户协议
  Widget _buildAgreeUserProtocol(BuildContext context) {
    return <Widget>[
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
        );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return SingleChildScrollView(
      child: <Widget>[
            // 头部标题
            const PageTitleWidget().paddingTop(50.w),

            // 表单
            _buildForm(context).card(
              color: context.colors.scheme.surface,
              margin: EdgeInsets.zero,
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.zero,
              // ),
            ),

            // 同意用户协议
            _buildAgreeUserProtocol(context),
          ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingHorizontal(AppSpace.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
