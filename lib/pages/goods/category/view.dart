import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/index.dart';
import 'index.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  // 左侧导航
  Widget _buildLeftNav(BuildContext context) {
    return GetBuilder<CategoryController>(
      id: "left_nav", // 唯一标识
      builder: (_) {
        return ListView.separated(
              itemBuilder: (context, index) {
                var item = controller.categoryItems[index]; // 分类项数据
                return CategoryListItemWidget(
                  category: item, // 分类数据
                  selectId: controller.categoryId, // 选中代码
                  onTap: controller.onCategoryTap, // tap 事件
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: AppSpace.listRow.w); // 间距
              },
              itemCount: controller.categoryItems.length, // 分类项数量
            )
            // 指定宽度 100
            .width(100.w)
            // 背景色
            .decorated(color: context.colors.scheme.surface)
            // 右上，右下 裁剪圆角
            .clipRRect(
              topRight: AppRadius.card.w,
              bottomRight: AppRadius.card.w,
            );
      },
    );
  }

  /// 右侧商品列表
  Widget _buildProductList(BuildContext context) {
    return Expanded(
      child: GetBuilder<CategoryController>(
        id: "product_list",
        builder: (_) {
          return SmartRefresher(
            controller: controller.refreshController, // 刷新控制器
            enablePullUp: true, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            onLoading: controller.onLoading, // 上拉加载回调
            child:
                controller.items.isEmpty
                    ? const Center(child: PlaceholdWidget())
                    : GridView.builder(
                      itemCount: controller.items.length, // 数据长度
                      itemBuilder: (context, index) {
                        var product = controller.items[index]; // 商品项数据
                        // 商品项组件
                        return ProductItemWidget(
                          product, // 商品
                          imgHeight: 117.w, // 图片高度
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 每行2个
                        mainAxisSpacing: AppSpace.listRow, // 主轴间距
                        crossAxisSpacing: AppSpace.listItem, // 交叉轴间距
                        childAspectRatio: 0.8, // 宽高比
                      ),
                      padding: EdgeInsets.all(AppSpace.page),
                    ),
          );
        },
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Row(
      children: [
        // 左侧导航
        _buildLeftNav(context),
        // 右侧商品列表
        _buildProductList(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      init: CategoryController(),
      id: "category",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("category")),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
