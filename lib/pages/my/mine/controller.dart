import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weichat_test/common/models/woo/news_model/news_model.dart';

class MineController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MineController();

  // 全局 key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  // tab 控制器
  late TabController tabController;
  // tab 控制器
  int tabIndex = 0;

  // 快讯收藏 items
  List<NewsModel> items = [
    NewsModel(
      id: 1,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),  
    NewsModel(
      id: 2,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),  
    NewsModel(
      id: 3,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),    

    NewsModel(
      id: 4,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),  
    NewsModel(
      id: 5,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),  
    NewsModel(
      id: 6,
      title: "快讯收藏", 
      subtitle: "快讯收藏", 
      collectionCount: '10',
    ),    
  ];

  _initData() {
    // 初始化 tab 控制器
    tabController = TabController(length: 3, vsync: this);

    // 监听 tab 切换
    addListenerTab();

    // 更新数据
    update(["mine"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  void addListenerTab() {
    tabController.addListener(() {
      tabIndex = tabController.index;
      update(['mine']);
    });
  }

  // 切换 tab
  void onTapBarTap(int index) {
    tabIndex = index;
    tabController.animateTo(index);
    update(["mine"]);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

    // 筛选 关闭
  void onFilterCloseTap() {
    Get.back();
  }
  
  // 筛选 打开
  void onFilterOpenTap() {
    scaffoldKey.currentState?.openEndDrawer();
  }


}
