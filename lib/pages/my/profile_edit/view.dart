import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:validatorless/validatorless.dart';

import '../../../common/index.dart';
import 'index.dart';

class ProfileEditPage extends GetView<ProfileEditController> {
  const ProfileEditPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return SingleChildScrollView(
      child: <Widget>[
        // 头像
        _buildAvatar(context),

        // 表单
        Form(
          key: controller.formKey, //设置globalKey，用于后面获取FormState
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:
              <Widget>[
                // profile 表单
                _buildProfileForm(context),
                // password 表单
                _buildPasswordForm(context),
              ].toColumn(),
        ).paddingBottom(AppSpace.card),

        // 保存按钮
        ButtonWidget.primary(
          LocaleKeys.commonBottomSave.tr,
          onTap: controller.onSave,
        ).width(double.infinity),
      ].toColumn().paddingAll(AppSpace.card),
    );
  }

  // 头像
  Widget _buildAvatar(BuildContext context) {
    return ListTileWidget(
          title: TextWidget.label(LocaleKeys.profileEditMyPhoto.tr),
          trailing: [
            controller.userPhoto != null
                ? AssetEntityImage(
                  controller.userPhoto!,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                ).clipOval()
                : ImageWidget.img(
                  // UserService.to.profile.avatarUrl,
                  "https://ducafecat-pub.oss-cn-qingdao.aliyuncs.com/avatar/00258VC3ly1gty0r05zh2j60ut0u0tce02.jpg",
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  radius: 25.w,
                ),
          ],
          padding: EdgeInsets.all(AppSpace.card),
          onTap: controller.onSelectPhoto,
        )
        .card(
          color: context.colors.scheme.surface,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        )
        .paddingBottom(AppSpace.card);
  }

  //  profile 表单
  Widget _buildProfileForm(BuildContext context) {
    return <Widget>[
      // first name
      InputFormFieldWidget(
        controller: controller.firstNameController,
        labelText: LocaleKeys.profileEditFirstName.tr,
        validator: Validatorless.multiple([
          Validatorless.required("The field is obligatory"),
          Validatorless.min(
              3, "Length cannot be less than @size".trParams({"size": "3"})),
          Validatorless.max(18,
              "Length cannot be greater than @size".trParams({"size": "18"})),
        ]),
      ),

      // last name
      InputFormFieldWidget(
        controller: controller.lastNameController,
        labelText: LocaleKeys.profileEditLastName.tr,
        validator: Validatorless.multiple([
          Validatorless.required("The field is obligatory"),
          Validatorless.min(
              3, "Length cannot be less than @size".trParams({"size": "3"})),
          Validatorless.max(18,
              "Length cannot be greater than @size".trParams({"size": "18"})),
        ]),
      ),

      // Email
      InputFormFieldWidget(
        keyboardType: TextInputType.emailAddress,
        controller: controller.emailController,
        labelText: LocaleKeys.profileEditEmail.tr,
        validator: Validatorless.multiple([
          Validatorless.required("The field is obligatory"),
          Validatorless.email(LocaleKeys.validatorEmail.tr),
        ]),
      ),
      // end
    ]
        .toColumn()
        .paddingAll(AppSpace.card)
        .card(
          color: context.colors.scheme.surface,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0.1,
        )
        .paddingBottom(AppSpace.card);
  }

  //  password 表单
  Widget _buildPasswordForm(BuildContext context) {
    return <Widget>[
      // old password
      InputFormFieldWidget(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: controller.oldPasswordController,
        labelText: LocaleKeys.profileEditOldPassword.tr,
        tipText: LocaleKeys.profileEditPasswordTip.tr,
        validator: Validatorless.multiple([
          Validatorless.min(
              3, "Length cannot be less than @size".trParams({"size": "3"})),
          Validatorless.max(18,
              "Length cannot be greater than @size".trParams({"size": "18"})),
        ]),
      ),

      // new password
      InputFormFieldWidget(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: controller.newPasswordController,
        labelText: LocaleKeys.profileEditNewPassword.tr,
        tipText: LocaleKeys.profileEditPasswordTip.tr,
        validator: Validatorless.multiple([
          Validatorless.min(
              3, "Length cannot be less than @size".trParams({"size": "3"})),
          Validatorless.max(18,
              "Length cannot be greater than @size".trParams({"size": "18"})),
        ]),
      ),

      // confirm password
      InputFormFieldWidget(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: controller.confirmNewPasswordController,
        labelText: LocaleKeys.profileEditConfirmPassword.tr,
        tipText: LocaleKeys.profileEditPasswordTip.tr,
        validator: Validatorless.multiple([
          Validatorless.min(
              3, "Length cannot be less than @size".trParams({"size": "3"})),
          Validatorless.max(18,
              "Length cannot be greater than @size".trParams({"size": "18"})),
        ]),
      ),

      // end
    ].toColumn().paddingAll(AppSpace.card).card(
          color: context.colors.scheme.surface,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0.1,
        );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileEditController>(
      init: ProfileEditController(),
      id: "profile_edit",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("profile_edit")),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
