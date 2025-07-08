import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import '../../../common/index.dart';
import 'index.dart';

class MyAddressPage extends GetView<MyAddressController> {
  const MyAddressPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: <Widget>[
        // 表单
        _buildForm().paddingBottom(30.h),

        // 保存按钮
        ButtonWidget.primary(
          LocaleKeys.commonBottomSave.tr,
          onTap: controller.onSave,
          height: 40,
        ),
      ].toColumn().paddingAll(AppSpace.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAddressController>(
      init: MyAddressController(),
      id: "my_address",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("my_address")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }

  // 表单
  Widget _buildForm() {
    return Form(
      key: controller.formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child:
          <Widget>[
            // first name
            InputFormFieldWidget(
              labelText: LocaleKeys.addressFirstName.tr,
              controller: controller.firstNameController,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
                Validatorless.min(
                  3,
                  "Length cannot be less than @size".trParams({"size": "3"}),
                ),
                Validatorless.max(
                  18,
                  "Length cannot be greater than @size".trParams({
                    "size": "18",
                  }),
                ),
              ]),
            ),

            // last name
            InputFormFieldWidget(
              labelText: LocaleKeys.addressLastName.tr,
              controller: controller.lastNameController,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
                Validatorless.min(
                  3,
                  "Length cannot be less than @size".trParams({"size": "3"}),
                ),
                Validatorless.max(
                  18,
                  "Length cannot be greater than @size".trParams({
                    "size": "18",
                  }),
                ),
              ]),
            ),

            // Country
            InputFormFieldWidget(
              controller: controller.countryController,
              labelText: LocaleKeys.addressCountry.tr,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
              ]),
              suffix: IconWidget.icon(
                Icons.arrow_drop_down,
                size: 20,
                onTap: controller.onCountryPicker,
              ),
              readOnly: true,
              onTap: controller.onCountryPicker,
            ),

            // State
            InputFormFieldWidget(
              controller: controller.statesController,
              labelText: LocaleKeys.addressState.tr,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
              ]),
              suffix: IconWidget.icon(
                Icons.arrow_drop_down,
                size: 20,
                onTap: controller.onStatesPicker,
              ),
              readOnly: true,
              onTap: controller.onStatesPicker,
            ),

            // Post Code
            InputFormFieldWidget(
              controller: controller.postCodeController,
              labelText: LocaleKeys.addressPostCode.tr,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
                Validatorless.min(
                  3,
                  "Length cannot be less than @size".trParams({"size": "3"}),
                ),
                Validatorless.max(
                  12,
                  "Length cannot be greater than @size".trParams({
                    "size": "12",
                  }),
                ),
              ]),
            ),

            // City
            InputFormFieldWidget(
              controller: controller.cityController,
              labelText: LocaleKeys.addressCity.tr,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
              ]),
            ),

            // Address 1
            InputFormFieldWidget(
              controller: controller.address1Controller,
              labelText: LocaleKeys.addressAddress1.tr,
              validator: Validatorless.multiple([
                Validatorless.required("The field is obligatory"),
              ]),
            ),

            // Address 2
            InputFormFieldWidget(
              controller: controller.address2Controller,
              labelText: LocaleKeys.addressAddress2.tr,
            ),

            // Company
            InputFormFieldWidget(
              controller: controller.companyController,
              labelText: LocaleKeys.addressCompany.tr,
            ),

            // Phone Number
            if (controller.type == "Billing")
              InputFormFieldWidget(
                keyboardType: TextInputType.phone,
                controller: controller.phoneNumberController,
                labelText: LocaleKeys.addressPhoneNumber.tr,
                validator: Validatorless.multiple([
                  Validatorless.required("The field is obligatory"),
                  Validatorless.min(
                    3,
                    "Length cannot be less than @size".trParams({"size": "3"}),
                  ),
                  Validatorless.max(
                    12,
                    "Length cannot be greater than @size".trParams({
                      "size": "12",
                    }),
                  ),
                ]),
              ),

            // Email
            if (controller.type == "Billing")
              InputFormFieldWidget(
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                labelText: LocaleKeys.addressEmail.tr,
                validator: Validatorless.multiple([
                  Validatorless.required("The field is obligatory"),
                  Validatorless.email(LocaleKeys.validatorEmail.tr),
                ]),
              ),

            // end
          ].toColumn(),
    );
  }
}
