import 'package:get/get.dart';

import '../../../common/index.dart';

class TestResultController extends GetxController {
  TestResultController();

  _initData() {
    update(["test_result"]);
  }

  // 开始测试
  void startTest() {  
    Get.toNamed(RouteNames.testResult, arguments: {});
  }

  // 分享结果
  void shareResult() {
    // Implement share result functionality here      
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
