import 'package:get/get.dart';
import 'package:weichat_test/common/routers/index.dart';

class PersontestController extends GetxController {
  PersontestController();

  // 开始测试
  void startTest() {
    Get.toNamed(RouteNames.testResult, arguments: {});
  }

  _initData() {
    update(["persontest"]);
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
