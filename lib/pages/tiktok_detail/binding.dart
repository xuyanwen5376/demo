import 'package:get/get.dart';

import 'controller.dart';

class TiktokDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TiktokDetailController>(() => TiktokDetailController());
  }
}
