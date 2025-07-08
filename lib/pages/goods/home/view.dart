import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/index.dart';
import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  // 导航栏
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // 背景透明
      backgroundColor: Colors.transparent,

      // 系统状态栏样式
      systemOverlayStyle:
          Get.context?.platformBrightness() == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,

      // 取消阴影
      // elevation: 0,
      // 标题栏左侧间距
      titleSpacing: AppSpace.listItem,
      // 搜索栏
      title: <Widget>[
            // 搜索
            IconWidget.icon(
              Icons.search_outlined,
              text: LocaleKeys.gHomeNewProduct.tr,
              size: 24,
              color: context.colors.scheme.outline,
            ).expanded(),

            // 分割线
            SizedBox(
              width: 2,
              height: 18,
              child: Container(color: context.colors.scheme.outline),
            ).paddingHorizontal(AppSpace.iconTextSmail),

            // 拍照
            IconWidget.icon(
              Icons.camera_alt_outlined,
              size: 24,
              color: AppColors.onSurface,
            ),
          ]
          .toRow()
          .padding(left: 20, top: 5, right: 10, bottom: 5)
          .decorated(
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: Border.all(color: context.colors.scheme.outline, width: 1),
          )
          .tight(height: 40.h)
          .paddingLeft(10)
          .onTap(controller.onAppBarTap),
      // 右侧的按钮区
      actions: [
        // 图标
        const IconWidget.svg(
              AssetsSvgs.pNotificationsSvg,
              size: 16,
              isDot: true, // 未读消息 小圆点
            )
            .unconstrained() // 去掉约束, appBar 会有个约束下来
            .padding(left: AppSpace.listItem, right: AppSpace.page),
      ],
    );
  }

  // 轮播广告
  Widget _buildBanner() {
    return GetBuilder<HomeController>(
          id: "home_banner",
          builder: (_) {
            return CarouselWidget(
              items: controller.bannerItems,
              currentIndex: controller.bannerCurrentIndex,
              onPageChanged: controller.onChangeBanner,
              height: 190.w,
            );
          },
        )
        .clipRRect(all: AppRadius.image)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // 分类导航
  Widget _buildCategories() {
    return <Widget>[
          for (var i = 0; i < controller.categoryItems.length; i++)
            CategoryListItemWidget(
              category: controller.categoryItems[i],
              onTap: (categoryId) => controller.onCategoryTap(categoryId),
            ).paddingRight(AppSpace.listItem),
        ]
        .toListView(scrollDirection: Axis.horizontal)
        .height(90.w)
        .paddingVertical(AppSpace.listRow)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // Flash Sell
  Widget _buildFlashSell() {
    return <Widget>[
          for (var i = 0; i < controller.flashShellProductList.length; i++)
            ProductItemWidget(
                  controller.flashShellProductList[i],
                  imgHeight: 117.w,
                  imgWidth: 120.w,
                )
                .constrained(width: 120.w, height: 170.w)
                .paddingRight(AppSpace.listItem),
        ]
        .toListView(scrollDirection: Axis.horizontal)
        .height(170.w)
        .paddingBottom(AppSpace.listRow)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // 新商品
  Widget _buildNewSell() {
    return GetBuilder<HomeController>(
      id: "home_news_sell",
      builder: (_) {
        return SliverGrid(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int position,
              ) {
                var product = controller.newProductProductList[position];
                return ProductItemWidget(product, imgHeight: 170.w);
              }, childCount: controller.newProductProductList.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpace.listRow,
                crossAxisSpacing: AppSpace.listItem,
                childAspectRatio: 0.8,
              ),
            )
            .sliverPadding(bottom: AppSpace.page)
            .sliverPaddingHorizontal(AppSpace.page);
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        // 轮播广告
        _buildBanner(),

        // 分类导航
        _buildCategories(),

        // Flash Sell
        // title
        Text(
          LocaleKeys.gHomeFlashSell.tr,
        ).sliverToBoxAdapter().sliverPaddingHorizontal(AppSpace.page),

        // 栏位标题
        controller.flashShellProductList.isNotEmpty
            ? BuildListTitle(
              title: LocaleKeys.gHomeFlashSell.tr,
              subTitle: "03. 30. 30",
              onTap: () => controller.onAllTap(true),
            ).sliverToBoxAdapter().sliverPaddingHorizontal(AppSpace.page)
            : const SliverToBoxAdapter(),

        // list
        _buildFlashSell(),

        // new product
        // title
        // 栏位标题
        controller.newProductProductList.isNotEmpty
            ? BuildListTitle(
              title: LocaleKeys.gHomeNewProduct.tr,
              subTitle: "03. 30. 30",
              onTap: () => controller.onAllTap(false),
            ).sliverToBoxAdapter().sliverPaddingHorizontal(AppSpace.page)
            : const SliverToBoxAdapter(),

        // list
        _buildNewSell(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return Scaffold(
          appBar: _buildAppBar(context),
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
