import 'dart:convert';
 
import 'package:get/get.dart';

import '../../../common/components/refresh_mixin.dart';
import '../../../common/index.dart';

class HomeController extends GetxController with RefreshMixin {
  HomeController();

  // Banner 当前位置
  int bannerCurrentIndex = 0;

  // Banner 数据
  List<KeyValueModel> bannerItems = [];

  // 分类导航数据
  List<CategoryModel> categoryItems = [];
  // 推荐商品列表数据
  List<ProductModel> flashShellProductList = [];
  // 最新商品列表数据
  List<ProductModel> newProductProductList = [];

  // 颜色
  List<AttributeModel> attributeColors = [];

  // 尺寸
  List<AttributeModel> attributeSizes = [];

  @override
  Future<List<ProductModel>> loadPageData({
    required int page,
    required int limit,
  }) async {
    return await ProductApi.products(ProductsReq(page: page, prePage: limit));
  }

  @override
  void onDataRefreshed(List data) {
    newProductProductList = List<ProductModel>.from(data);
    update(["home_news_sell"]);
  }

  @override
  void onDataLoaded(List data) {
    newProductProductList.addAll(List<ProductModel>.from(data));
    update(["home_news_sell"]);
  }

  // Banner 切换事件
  void onChangeBanner(int index, /*CarouselPageChangedReason*/ reason) {
    bannerCurrentIndex = index;
    update(["home_banner"]);
  }

  // 分类点击事件
  void onCategoryTap(int categoryId) {
    Get.toNamed(RouteNames.goodsCategory, arguments: {"id": categoryId});
  }

  // 推荐商品点击事件
  void onFlashShellTap(int productId) {}

  // 最新商品点击事件
  void onNewProductTap(int productId) {}

  // ALL 点击事件
  void onAllTap(bool featured) {
    // print(featured);
    Get.toNamed(RouteNames.goodsProductList, arguments: {"featured": featured});
  }

  // 导航点击事件
  void onAppBarTap() {
    Get.toNamed(RouteNames.searchSearchIndex);
  }

  _initData() async {
    // 首页
    // banner
    bannerItems = await SystemApi.banners();

    // 分类
    categoryItems = await ProductApi.categories();
    // 推荐商品
    flashShellProductList = await ProductApi.products(
      ProductsReq(featured: true),
    );
    // 新商品
    newProductProductList = await ProductApi.products(ProductsReq());

    // 颜色
    attributeColors = await ProductApi.attributes(1);

    // 尺寸
    attributeSizes = await ProductApi.attributes(2);

        // 品牌
    var attributeBrand = await ProductApi.attributes(3);
    // 性别
    var attributeGender = await ProductApi.attributes(4);
    // 新旧
    var attributeCondition = await ProductApi.attributes(5);
 
    // 保存离线数据 - 分类
    Storage().setJson(Constants.storageProductsCategories, categoryItems);
    Storage().setString(
        Constants.storageProductsAttributesBrand, jsonEncode(attributeBrand));
    Storage().setString(
        Constants.storageProductsAttributesGender, jsonEncode(attributeGender));
    Storage().setString(Constants.storageProductsAttributesCondition,
        jsonEncode(attributeCondition));



    // 基础
    Storage().setJson(
      Constants.storageProductsAttributesColors,
      attributeColors,
    );
    Storage().setJson(Constants.storageProductsAttributesSizes, attributeSizes);

    update(["home"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    // 刷新控制器释放
    refreshController.dispose();
  }

  @override
  Future<void> onLoading() async {
    if (!hasMore) {
      refreshController.loadNoData();
      return;
    }
    try {
      final data = await loadPageData(page: page + 1, limit: limit);
      if (data.isEmpty) {
        hasMore = false;
        refreshController.loadNoData();
      } else {
        page++;
        onDataLoaded(data);
        if (data.length < limit) {
          hasMore = false;
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
    } catch (e) {
      refreshController.loadFailed();
    }
  }
}
