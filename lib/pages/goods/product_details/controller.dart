import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';

class ProductDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ProductDetailsController();

  int? productId = Get.arguments['id'] ?? 0;

  ProductModel? product;

  // Banner 数据
  List<KeyValueModel> bannerItems = [];

  int bannerCurrentIndex = 0;

  // tab 控制器
  late TabController tabController;
  // tab 控制器
  int tabIndex = 0;

  // 颜色列表
  List<KeyValueModel<AttributeModel>> colors = [];
  // 选中颜色列表
  List<String> colorKeys = [];

  // 尺寸列表
  List<KeyValueModel<AttributeModel>> sizes = [];
  // 选中尺寸列表
  List<String> sizeKeys = [];

  // reviews 评论列表
  List<ReviewModel> reviews = [];

  _initData() async {
    // 初始化 tab 控制器
    tabController = TabController(length: 3, vsync: this);

    // 商品详情
    await _loadProduct();

    // reviews 评论列表
    await _loadReviews();

    // 读取缓存
    await _loadCache();

    // 监听 tab 切换
    addListenerTab();

    update(["product_details"]);
  }

  void addListenerTab() {
    tabController.addListener(() {
      tabIndex = tabController.index;
      update(['product_tab']);
    });
  }

  void onChangeBanner(int index, reason) {
    bannerCurrentIndex = index;
    update(["product_banner"]);
  }

  // 图片浏览
  void onGalleryTap(int index, KeyValueModel item) {
    Get.to(
      GalleryWidget(
        initialIndex: index,
        imgUrls: bannerItems.map<String>((e) => e.value!).toList(),
      ),
    );
  }

  // 切换 tab
  void onTapBarTap(int index) {
    tabIndex = index;
    tabController.animateTo(index);
    update(["product_tab"]);
  }

  void onTap() {}
  // 颜色选中
  void onColorTap(List<String> keys) {
    colorKeys = keys;
    update(["product_colors"]);
  }

  // 尺寸选中
  void onSizeTap(List<String> keys) {
    sizeKeys = keys;
    update(["product_sizes"]);
  }

  // 加入购物车
  Future<void> onAddCartTap() async {
    // print('加入购物车');
   // 检查是否登录
    if (!await UserService.to.checkIsLogin()) {
      return;
    }

    // 检查空
    if (product == null || product?.id == null) {
      Loading.error("product is empty");
      return;
    }

    // 加入购物车
    CartService.to.addCart(LineItem(
      productId: productId,
      product: product,
    ));
    // 返回、或者去购物车
    Get.back();

  }




  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 商品详情
  _loadProduct() async {
    product = await ProductApi.productDetail(productId.toString());

    // Banner 数据
    if (product?.images != null) {
      bannerItems =
          product!.images!
              .map<KeyValueModel>(
                (e) => KeyValueModel(key: "${e.id}", value: e.src ?? ""),
              )
              .toList();
    }
  }

  // reviews 评论列表
  _loadReviews() async {
    reviews = await ProductApi.reviews(ReviewsReq(product: productId));
  }

  // 读取缓存
  _loadCache() async {
    // 颜色列表
    var stringColors = Storage().getString(
      Constants.storageProductsAttributesColors,
    );

    colors =
        stringColors != ""
            ? jsonDecode(stringColors).map<KeyValueModel<AttributeModel>>((
              item,
            ) {
              var arrt = AttributeModel.fromJson(item);
              return KeyValueModel(key: "${arrt.name}", value: arrt);
            }).toList()
            : [];

    // 尺寸列表
    var stringSizes = Storage().getString(
      Constants.storageProductsAttributesSizes,
    );

    sizes =
        stringSizes != ""
            ? jsonDecode(stringSizes).map<KeyValueModel<AttributeModel>>((
              item,
            ) {
              var arrt = AttributeModel.fromJson(item);
              return KeyValueModel(key: "${arrt.name}", value: arrt);
            }).toList()
            : [];
  }

  @override
  void onClose() {
    super.onClose();

    tabController.dispose();
  }
}
