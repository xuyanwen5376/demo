import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';
import 'widgets/index.dart';

class ProductDetailsPage extends GetView<ProductDetailsController> {
  const ProductDetailsPage({super.key});

  // 滚动图
  Widget _buildBanner(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      id: "product_banner",
      // tag: tag,
      builder: (_) {
        return CarouselWidget(
          // 打开大图预览
          onTap: controller.onGalleryTap,
          // 图片列表
          items: controller.bannerItems,
          // 当前索引
          currentIndex: controller.bannerCurrentIndex,
          // 切换回调
          onPageChanged: controller.onChangeBanner,
          // 高度
          height: 190.w,
          // 指示器圆点
          indicatorCircle: false,
          // 指示器位置
          indicatorAlignment: MainAxisAlignment.start,
          // 指示器颜色
          indicatorColor: context.colors.scheme.secondary,
        );
      },
    ).backgroundColor(context.colors.scheme.surface);
  }

  // 商品标题
  Widget _buildTitle(BuildContext context) {
    return <Widget>[
      <Widget>[
        TextWidget.h2("￥${controller.product?.price ?? "0"}"),
        TextWidget.label(controller.product?.name ?? "-"),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),
      IconWidget(
        type: IconWidgetType.icon,
        iconData: Icons.star,
        text: "4.5",
        size: 20,
        color: context.colors.scheme.primary,
      ).paddingRight(AppSpace.iconTextMedium),
      IconWidget(
        type: IconWidgetType.icon,
        iconData: Icons.favorite,
        text: "100+",
        size: 20,
        color: context.colors.scheme.primary,
      ).paddingRight(AppSpace.iconTextMedium),
    ].toRow().paddingAll(AppSpace.page);
  }

  // Tab 栏位
  Widget _buildTabBar(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      // tag: tag,
      id: "product_tab",
      builder: (_) {
        return <Widget>[
          _buildTabBarItem(context, LocaleKeys.gDetailTabProduct.tr, 0),
          _buildTabBarItem(context, LocaleKeys.gDetailTabDetails.tr, 1),
          _buildTabBarItem(context, LocaleKeys.gDetailTabReviews.tr, 2),
        ].toRowSpace(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  // TabView 视图
  Widget _buildTabView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0.w, 20.w, 0.w),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            // 规格
            TabProductView(),
            // 详情
            TabDetailView(),
            // 评论
            TabReviewsView(),
          ],
        ),
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return controller.product == null
        ? const PlaceholdWidget() // 占位图
        : <Widget>[
          // 滚动图
          _buildBanner(context),

          // 商品标题
          _buildTitle(context),

          // Tab 栏位
          _buildTabBar(context),

          // TabView 视图
          _buildTabView(),
        ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(),
      id: "product_details",
      builder: (_) {
        return Scaffold(
          appBar: mainAppBarWidget(
            titleString: controller.product?.name ?? LocaleKeys.gDetailTitle.tr,
          ),
          body: SafeArea(
            // child: _buildView(context),
            child:
                <Widget>[
                  _buildView(context).expanded(),
                  _buildButtons(context),
                ].toColumn(),
          ),
        );
      },
    );
  }

  // Tab 栏位按钮
  Widget _buildTabBarItem(BuildContext context, String textString, int index) {
    return ButtonWidget.outline(
      textString,
      onTap: () => controller.onTapBarTap(index),
      borderRadius: 17,
      borderColor: Colors.transparent,
      textColor:
          controller.tabIndex == index
              ? context.colors.scheme.onSecondary
              : context.colors.scheme.onPrimaryContainer,
      backgroundColor:
          controller.tabIndex == index
              ? context.colors.scheme.primary
              : context.colors.scheme.onPrimary,
    ).tight(width: 100.w, height: 35.h);
  }

  // 底部按钮
  Widget _buildButtons(BuildContext context) {
    return <Widget>[
          // 加入购物车
          ButtonWidget.secondary(
            LocaleKeys.gDetailBtnAddCart.tr,
            onTap: () {
              controller.onAddCartTap();
            },
          ).expanded(),

          // 间距
          SizedBox(width: AppSpace.iconTextLarge),

          // 立刻购买
          ButtonWidget.primary(LocaleKeys.gDetailBtnBuy.tr).expanded(),
        ]
        .toRow(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
        .paddingHorizontal(AppSpace.page);
  }
}
