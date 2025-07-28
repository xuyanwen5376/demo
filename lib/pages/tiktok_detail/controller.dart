import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../common/index.dart';

class TiktokDetailController extends GetxController {
  // 滚动控制器
  final ScrollController scrollController = ScrollController();

  // 收藏状态
  bool isFavorite = false;

  // 收藏数量
  int favoriteCount = 888;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  // 初始化数据
  _initData() {
    update(["tiktok_detail"]);
  }

  // 切换收藏
  void toggleFavorite() {
    isFavorite = !isFavorite;
    favoriteCount = isFavorite ? favoriteCount + 1 : favoriteCount - 1;
    update(["tiktok_detail"]);
  }

  // 分享内容
  void shareContent() {
    // 实现分享功能
    EasyLoading.showToast('分享功能开发中...');
  }

  // AI解读内容
  void analyzeWithAI() {
    // 实现AI解读功能
    EasyLoading.showToast('AI解读功能开发中...');
  }

  @override
  void onClose() {
    // 释放控制器
    scrollController.dispose();
    super.onClose();
  }
}
