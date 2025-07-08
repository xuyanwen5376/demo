import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/index.dart';
import 'index.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  // 主视图
  Widget _buildView() {
    return <Widget>[
      // 表单
      _buildForm(),

      // 注册按钮
      _buildBtnSignUp(),

      <Widget>[
        // 提示文字
        _buildTips().padding(
          right: 10,
        ),
        // 登录按钮
        _buildBtnSignIn(),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, 
      ).paddingAll(AppSpace.page),


    ].toColumn().paddingAll(AppSpace.page);
  }

  // 注册按钮
  Widget _buildBtnSignUp() {
    return ButtonWidget.primary(
      LocaleKeys.loginSignUp.tr,
      onTap: controller.onSignUp,
    ).tight(
      width: double.infinity,
      height: 40,
    );
  }

  // 提示文字
  Widget _buildTips() {
    return TextWidget.h2(LocaleKeys.registerHaveAccount.tr);
  }

  // 登录按钮
  Widget _buildBtnSignIn() {
    return ButtonWidget.link(
      LocaleKeys.loginSignIn.tr,
      onTap: controller.onSignIn,
    );
  }


  // 表单页
  Widget _buildForm() {
    return Form(
      key: controller.formKey, // 设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget>[
        // username
        InputFormFieldWidget(
          autofocus: true,
          controller: controller.userNameController,
          labelText: LocaleKeys.registerFormName.tr,
          prefix: const Icon(Icons.person),
          suffix: const Icon(Icons.done),
          validator: Validatorless.multiple([
            Validatorless.required(LocaleKeys.validatorRequired.tr),
            Validatorless.min(
                3, LocaleKeys.validatorMin.trParams({"size": "3"})),
            Validatorless.max(
                20, LocaleKeys.validatorMax.trParams({"size": "20"})),
          ]),
        ).paddingBottom(AppSpace.listRow.w),

        // email
        InputFormFieldWidget(
          controller: controller.emailController,
          labelText: LocaleKeys.registerFormEmail.tr,
          keyboardType: TextInputType.emailAddress,
          prefix: const Icon(Icons.email),
          suffix: const Icon(Icons.done),
          // validator: Validatorless.multiple([
          //   Validatorless.required(LocaleKeys.validatorRequired.tr),
          //   Validatorless.email(LocaleKeys.validatorEmail.tr),
          // ]),
        ).paddingBottom(AppSpace.listRow.w),

        // first name
        InputFormFieldWidget(
          controller: controller.firstNameController,
          labelText: LocaleKeys.registerFormFirstName.tr,
          prefix: const Icon(Icons.person),
          suffix: const Icon(Icons.done),
          // validator: Validatorless.multiple([
          //   Validatorless.required(LocaleKeys.validatorRequired.tr),
          //   Validatorless.min(
          //       3, LocaleKeys.validatorMin.trParams({"size": "3"})),
          //   Validatorless.max(
          //       20, LocaleKeys.validatorMax.trParams({"size": "20"})),
          // ]),
        ).paddingBottom(AppSpace.listRow.w),

        // last name
        InputFormFieldWidget(
          controller: controller.lastNameController,
          labelText: LocaleKeys.registerFormLastName.tr,
          prefix: const Icon(Icons.person),
          suffix: const Icon(Icons.done),
          // validator: Validatorless.multiple([
          //   Validatorless.required(LocaleKeys.validatorRequired.tr),
          //   Validatorless.min(
          //       3, LocaleKeys.validatorMin.trParams({"size": "3"})),
          //   Validatorless.max(
          //       20, LocaleKeys.validatorMax.trParams({"size": "20"})),
          // ]),
        ).paddingBottom(AppSpace.listRow.w),

        // password
        InputFormFieldWidget(
          controller: controller.passwordController,
          labelText: LocaleKeys.registerFormPassword.tr,
          prefix: const Icon(Icons.password),
          obscureText: true,
          suffix: const Icon(Icons.done),
          // validator: Validatorless.multiple([
          //   Validatorless.required(LocaleKeys.validatorRequired.tr),
          //   Validators.password(
          //     8,
          //     18,
          //     LocaleKeys.validatorPassword.trParams(
          //       {"min": "8", "max": "18"},
          //     ),
          //   ),
          // ]),
        ).paddingBottom(AppSpace.listRow.w * 2),

        //
      ].toColumn().paddingVertical(10),
    ).paddingAll(AppSpace.card);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      id: "register",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("register")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
