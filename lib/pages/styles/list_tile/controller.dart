import 'package:get/get.dart';

class ListTileController extends GetxController {
  ListTileController();

  _initData() {
    update(["list_tile"]);
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
