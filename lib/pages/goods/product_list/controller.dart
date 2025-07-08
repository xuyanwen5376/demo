import 'package:get/get.dart';

import '../../../common/components/refresh_mixin.dart';
import '../../../common/index.dart';

class ProductListController extends GetxController with RefreshMixin {
  ProductListController();

  /// 是否推荐商品
  final bool featured = Get.arguments['featured'] ?? false;

  // 列表
  List<ProductModel> items = [];

  _initData() {
    update(["product_list"]);
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
      ProductsReq(page: page, prePage: limit, featured: featured),
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
