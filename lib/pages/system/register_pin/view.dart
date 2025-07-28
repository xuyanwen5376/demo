import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/components/pin.dart';
import '../../../common/index.dart';
import 'index.dart';

class RegisterPinPage extends GetView<RegisterPinController> {
  const RegisterPinPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: <Widget>[
            // 头部标题
            PageTitleWidget(),

            // 表单
            _buildForm().card(),
          ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingHorizontal(AppSpace.page),
    );
  }

  // pin 表单页
  Widget _buildForm() {
    return Form(
      key: controller.formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child:
          <Widget>[
            // 提示文
            TextWidget.label(
              LocaleKeys.registerPinFormTip.tr,
            ).paddingBottom(20.w).alignLeft(),

            // pin
            PinPutWidget(
              controller: controller.pinController,
              validator: controller.pinValidator, // 验证函数
              onSubmit: controller.onPinSubmit,
            ).paddingBottom(50.w),

            // 提交按钮
            ButtonWidget.primary(
              LocaleKeys.registerPinButton.tr,
              onTap: controller.onBtnSubmit,
            ).paddingBottom(AppSpace.listRow),

            // 返回按钮
            ButtonWidget.ghost(
              LocaleKeys.commonBottomCancel.tr,
              onTap: controller.onBtnBackup,
            ),

            // end
          ].toColumn(),
    ).paddingAll(AppSpace.card);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterPinController>(
      init: RegisterPinController(),
      id: "register_pin",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("register_pin")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
