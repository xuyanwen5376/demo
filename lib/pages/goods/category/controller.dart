import 'dart:convert';

import 'package:get/get.dart';

import '../../../common/components/refresh_mixin.dart';
import '../../../common/index.dart';

class CategoryController extends GetxController with RefreshMixin {
  CategoryController();

  // 分类 id , 获取路由传递参数
  int? categoryId = Get.arguments['id'];
  // 分类导航数据
  List<CategoryModel> categoryItems = [];
  // 商品列表数据
  List<ProductModel> items = [];

  _initData() async {
    // 读缓存
    var stringCategories = Storage().getString(
      Constants.storageProductsCategories,
    );
    categoryItems =
        stringCategories != ""
            ? jsonDecode(stringCategories).map<CategoryModel>((item) {
              return CategoryModel.fromJson(item);
            }).toList()
            : [];

    // 如果本地缓存空
    if (categoryItems.isEmpty) {
      categoryItems = await ProductApi.categories(); // 获取分类数据
    }

    update(["category"]);
  }

  // 分类点击事件
  void onCategoryTap(int id) async {
    categoryId = id;
    update(["left_nav"]);
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
    refreshController.dispose();
  }

  @override
  Future<List<ProductModel>> loadPageData({
    required int page,
    required int limit,
  }) async {
    return await ProductApi.products(
      ProductsReq(page: page, prePage: limit, category: categoryId.toString()),
    );
  }

  @override
  void onDataRefreshed(List data) {
    items = List<ProductModel>.from(data);
    update(["product_list"]);
  }

  @override
  void onDataLoaded(List data) {
    items.addAll(List<ProductModel>.from(data));
    update(["product_list"]);
  }
}
