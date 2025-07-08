import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/api/timeline.dart';
import '../../common/index.dart';

class DynamicController extends GetxController {
  DynamicController();

  // 滚动控制器
  final ScrollController scrollController = ScrollController();

  // 用户资料
  UserModel? user;

  // 动态数据
  List<TimelineModel> items = [];

  _initData() async {
    
    // 初始用户资料
    user = UserModel(
      nickName: "kylelou",
      avatar:
          "https://ducafecat.oss-cn-beijing.aliyuncs.com/ducafecat/logo-500.png",
      cover:
          "https://ducafecat-pub.oss-cn-qingdao.aliyuncs.com/cover/activeprogrammer.jpg",
    );

    try {
      items = await TimelineApi.pageList(); 
    } catch (e) { 
      items = []; // 确保为空数组而不是 null
    }

    update(["dynamic"]); 
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

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  // //  监听  scrollController 动滚动高度
  // _scrollController.addListener(() {
  //   // 滚动条超过 200 时，开始渐变
  //   if (_scrollController.position.pixels > 200) {
  //     double opacity = (_scrollController.position.pixels - 200) / 100;
  //     if (opacity < 0.85) {
  //       setState(() {
  //         _appBarColor = Colors.black.withOpacity(opacity);
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       _appBarColor = null;
  //     });
  //   }
  // });
}
