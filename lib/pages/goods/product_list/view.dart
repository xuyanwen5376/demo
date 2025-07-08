import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/index.dart';
import 'index.dart';

class ProductListPage extends GetView<ProductListController> {
  const ProductListPage({super.key});

  // 主视图
  Widget _buildView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpace.listRow,
        crossAxisSpacing: AppSpace.listItem,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return ProductItemWidget(controller.items[index], imgHeight: 170.w);
      },
      itemCount: controller.items.length,
      padding: EdgeInsets.all(AppSpace.page),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductListController>(
      init: ProductListController(),
      id: "product_list",
      builder: (_) {
        return Scaffold(
          appBar: mainAppBarWidget(
            titleString:
                controller.featured == true
                    ? LocaleKeys.gFlashSellTitle.tr
                    : LocaleKeys.gNewsTitle.tr,
          ),
          body: SmartRefresher(
            controller: controller.refreshController, // 刷新控制器
            enablePullUp: true, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            onLoading: controller.onLoading, // 上拉加载回调
            // footer: const SmartRefresherFooterWidget(), // 底部加载更多
            child: _buildView(),
          ),
        );
      },
    );
  }
}
