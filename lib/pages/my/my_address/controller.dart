import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

import '../../../common/index.dart';

class MyAddressController extends GetxController {
  MyAddressController();

  // 地址类型 Billing 订单发票地址，Shipping 订单收货地址
  final String type = Get.arguments['type'] ?? "";

  // 表单 form
  GlobalKey formKey = GlobalKey<FormState>();
  // 输入框控制器
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController statesController = TextEditingController();

  // 大陆国家洲省
  List<ContinentsModel> continents = [];
  // 大陆国家数据
  List<PickerItem> countriesList = [];
  // 国家选择
  List<int> countrySels = [];
  // 洲省数据
  List<PickerItem> statesList = [];
  // 洲省市选择
  List<int> statesSels = [];

  // 初始化
  Future<void> _initData() async {
    // 用户数据初始
    UserProfileModel profile = UserService.to.profile;
    if (type == "Billing") {
      firstNameController.text = profile.billing?.firstName ?? "";
      lastNameController.text = profile.billing?.lastName ?? "";
      postCodeController.text = profile.billing?.postcode ?? "";
      cityController.text = profile.billing?.city ?? "";
      address1Controller.text = profile.billing?.address1 ?? "";
      address2Controller.text = profile.billing?.address2 ?? "";
      companyController.text = profile.billing?.company ?? "";
      phoneNumberController.text = profile.billing?.phone ?? "";
      emailController.text = profile.billing?.email ?? "";
      countryController.text = profile.billing?.country ?? "";
      statesController.text = profile.billing?.state ?? "";
    } else {
      firstNameController.text = profile.shipping?.firstName ?? "";
      lastNameController.text = profile.shipping?.lastName ?? "";
      postCodeController.text = profile.shipping?.postcode ?? "";
      cityController.text = profile.shipping?.city ?? "";
      address1Controller.text = profile.shipping?.address1 ?? "";
      address2Controller.text = profile.shipping?.address2 ?? "";
      companyController.text = profile.shipping?.company ?? "";
      countryController.text = profile.shipping?.country ?? "";
      statesController.text = profile.shipping?.state ?? "";
    }

    // 拉取 大陆国家数据
    await _fetchContinents();
    // 国家代码
    String countryCode = countryController.text;

    // 国家选着器 - 选中 index
    for (var i = 0; i < continents.length; i++) {
      // 大陆
      var continent = continents[i];
      // 检查是否有选中的国家
      int iCountryIndex =
          continent.countries?.indexWhere((el) => el.code == countryCode) ?? 0;
      if (iCountryIndex > 0) {
        [i, iCountryIndex];
        break;
      }
    }

    // 洲省代码
    String statesCode = statesController.text;
    // 洲选择器数据
    _filterStates(countryCode);
    // 洲省选择器 - 选中 index
    statesSels = [statesList.indexWhere((el) => el.value == statesCode)];

    update(["my_address"]);
  }

  // 国家选择
  void onCountryPicker() async {
    BottomSheetWidget.show(
      context: Get.context!,
      titleString: "国家",
      padding: 20,
      content:
          Picker(
            adapter: PickerDataAdapter(data: countriesList),
            selecteds: countrySels,
            itemExtent: 40,
            height: 270,
            backgroundColor: Colors.transparent,
            containerColor: Colors.transparent,
            cancelText: LocaleKeys.commonBottomCancel.tr,
            confirmText: LocaleKeys.commonBottomConfirm.tr,
            onConfirm: (Picker picker, List<int> value) {
              countrySels = value;
              final selectedValues = picker.getSelectedValues();
              if (selectedValues.isNotEmpty) {
                final selectedCountry = selectedValues.last as String;
                countryController.text = selectedCountry;
                _filterStates(selectedCountry); // 加入筛选 洲省
                update(["my_address"]);
              }
            },
          ).makePicker(),
    );
  }

  // 洲省市选择
  void onStatesPicker() async {
    BottomSheetWidget.show(
      context: Get.context!,
      titleString: "州/省",
      padding: 20,
      content:
          Picker(
            adapter: PickerDataAdapter(data: statesList),
            selecteds: statesSels,
            itemExtent: 40,
            height: 270,
            backgroundColor: Colors.transparent,
            containerColor: Colors.transparent,
            cancelText: LocaleKeys.commonBottomCancel.tr,
            confirmText: LocaleKeys.commonBottomConfirm.tr,
            onConfirm: (Picker picker, List<int> value) {
              statesSels = value;
              final selectedValues = picker.getSelectedValues();
              if (selectedValues.isNotEmpty) {
                final selectedState = selectedValues.last as String;
                statesController.text = selectedState;
                update(["my_address"]);
              }
            },
          ).makePicker(),
    );
  }

  // 保存
  Future<void> onSave() async {
    // 检查是否登录
    if (!UserService.to.isLogin) {
      Get.snackbar("提示", "请先登录", snackPosition: SnackPosition.TOP);
      // 跳转到登录页面
      Get.toNamed(RouteNames.systemLogin);
      return;
    }

    if ((formKey.currentState as FormState).validate()) {
      UserProfileModel? profile;
      if (type == "Billing") {
        // 设置账单地址
        var req = Billing(
          email: emailController.text,
          phone: phoneNumberController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          postcode: postCodeController.text,
          city: cityController.text,
          address1: address1Controller.text,
          address2: address2Controller.text,
          company: companyController.text,
          country: countryController.text,
          state: statesController.text,
        );
        profile = await UserApi.saveBillingAddress(req);
      } else if (type == "Shipping") {
        // 设置送货地址
        var req = Shipping(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          postcode: postCodeController.text,
          city: cityController.text,
          address1: address1Controller.text,
          address2: address2Controller.text,
          company: companyController.text,
          country: countryController.text,
          state: statesController.text,
        );
        profile = await UserApi.saveShippingAddress(req);
      }
      if (profile != null) {
        UserService.to.setProfile(profile);
        Get.back<bool>(result: true);
      }
    }
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
  }

  // 拉取大陆国家洲省数据
  Future<void> _fetchContinents() async {
    continents = await UserApi.continents();
    countriesList = List.generate(continents.length, (index) {
      var entity = continents[index];
      List<PickerItem> countryList = [];
      for (Country country in entity.countries ?? []) {
        countryList.add(
          PickerItem(
            text: Text(country.name ?? "-"),
            value: country.code ?? "-",
          ),
        );
      }
      return PickerItem(
        text: Text(entity.code ?? "-"),
        value: entity.name ?? "-",
        children: countryList,
      );
    });
  }

  // 取洲省数据
  void _filterStates(String countryCode) {
    for (var continent in continents) {
      var country = continent.countries?.firstWhereOrNull(
        (el) => el.code == countryCode,
      );
      if (country != null) {
        statesList = List.generate(country.states?.length ?? 0, (index) {
          var state = country.states?.elementAt(index);
          return PickerItem(
            text: Text(state?.name ?? "-"),
            value: state?.code ?? "-",
          );
        });
        break;
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    // 控制器释放
    firstNameController.dispose();
    lastNameController.dispose();
    postCodeController.dispose();
    cityController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    companyController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    countryController.dispose();
    statesController.dispose();
  }
}
