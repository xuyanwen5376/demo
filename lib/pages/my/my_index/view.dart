import 'dart:math';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/index.dart';
import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});

  // 顶部 APP 导航栏
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      // 背景色
      backgroundColor: Colors.transparent,
      // 固定在顶部
      pinned: true,
      // 浮动在顶部
      floating: true,
      // 自动弹性显示
      snap: true,
      // 是否应拉伸以填充过度滚动区域。
      stretch: true,
      // 高度
      expandedHeight: 280.h,
      // 此小组件堆叠在工具栏和选项卡栏后面。其高度将与应用栏的整体高度相同。
      flexibleSpace: FlexibleSpaceBar(
        // // // 折叠模式
        // collapseMode: CollapseMode.parallax,
        // // // 折叠动画
        // stretchModes: const [
        //   // 模糊
        //   StretchMode.blurBackground,
        //   // 尺寸
        //   StretchMode.zoomBackground,
        //   // 标题动画
        //   StretchMode.fadeTitle,
        // ],
        // // // 标题
        // title: const TextWidget.navigation(text: "Ducafecat"),
        // 背景
        background:
            <Widget>[
              // 背景图
              <Widget>[
                IconWidget.svg(
                  AssetsSvgs.profileHeaderBackgroundSvg,
                  color: context.colors.scheme.primary,
                  fit: BoxFit.cover,
                ).expanded(),
                // const ImageWidget.(
                //   AssetsImages.profileBackgroundPng,
                //   fit: BoxFit.cover,
                // ).expanded(),
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.stretch),

              // 内容
              <Widget>[
                // 用户信息
                <Widget>[
                  // 头像
                  ImageWidget.img(
                    // 测试需要改成自定义头像
                    "https://ducafecat-pub.oss-cn-qingdao.aliyuncs.com/avatar/00258VC3ly1gty0r05zh2j60ut0u0tce02.jpg",
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.fill,
                    radius: 50.w,
                  ).paddingRight(AppSpace.listItem),

                  // 称呼
                  TextWidget.h2(
                    // "${UserService.to.profile.username}",
                    "Ducafecat",
                    color: context.colors.scheme.onPrimary,
                  ),
                ].toRow().paddingHorizontal(AppSpace.card),

                // 功能栏位
                <Widget>[
                      // 1
                      BarItemWidget(
                        title: LocaleKeys.myTabWishlist.tr,
                        svgPath: AssetsSvgs.iLikeSvg,
                      ),
                      // 2
                      BarItemWidget(
                        title: LocaleKeys.myTabFollowing.tr,
                        svgPath: AssetsSvgs.iAddFriendSvg,
                      ),
                      // 3
                      BarItemWidget(
                        title: LocaleKeys.myTabVoucher.tr,
                        svgPath: AssetsSvgs.iCouponSvg,
                      ),
                    ]
                    .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
                    .paddingSymmetric(
                      // 水平
                      horizontal: AppSpace.card,
                      // 垂直
                      vertical: AppSpace.card * 2,
                    )
                    .card(color: context.colors.scheme.surface)
                    // 水平
                    .paddingHorizontal(AppSpace.page),
              ].toColumn(mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            ].toStack(),
      ),
    );
  }

  // My Order
  Widget _buildMyOrder(BuildContext context) {
    return _buildListItem(
      txtTitle: LocaleKeys.myBtnMyOrder.tr,
      svgPath: AssetsSvgs.pDeliverySvg,
      onTap: () => Get.toNamed(RouteNames.myOrderList),
    ).card().paddingVertical(AppSpace.page);
  }

  // 按钮列表
  Widget _buildButtonsList(BuildContext context) {
    return <Widget>[
      // Edit Profile
      _buildListItem(
        txtTitle: LocaleKeys.myBtnEditProfile.tr,
        svgPath: AssetsSvgs.pCurrencySvg,
        onTap: () => Get.toNamed(RouteNames.myProfileEdit),
      ),

      // Billing Address
      _buildListItem(
        txtTitle: LocaleKeys.myBtnBillingAddress.tr,
        svgPath: AssetsSvgs.pHomeSvg,
        onTap: () => controller.onToAddress("Billing"),
      ),

      // Billing Address
      _buildListItem(
        txtTitle: LocaleKeys.myBtnShippingAddress.tr,
        svgPath: AssetsSvgs.pHomeSvg,
        onTap: () => controller.onToAddress("Shipping"),
      ),

      // Language
      _buildListItem(
        txtTitle: LocaleKeys.myBtnLanguage.tr,
        svgPath: AssetsSvgs.pTranslateSvg,
        onTap: () => Get.toNamed(RouteNames.myLanguage),
      ),

      // 样式页
      _buildListItem(
        txtTitle: LocaleKeys.myBtnStyles.tr,
        svgPath: AssetsSvgs.cBagSvg,
        onTap: () => Get.toNamed(RouteNames.stylesStylesIndex),
      ),

      // Theme
      _buildListItem(
        txtTitle: LocaleKeys.myBtnTheme.tr,
        svgPath: AssetsSvgs.pThemeSvg,
        onTap: () => ConfigService.to.switchThemeMode(),
      ),

      // 调试工具
      _buildListItem(
        txtTitle: LocaleKeys.myBtnStyles.tr,
        svgPath: AssetsSvgs.pCurrencySvg,
        onTap: () => Get.toNamed(RouteNames.stylesStylesIndex),
      ),
    ].toColumn().card().paddingVertical(AppSpace.page);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // 顶部 APP 导航栏
        _buildAppBar(context),

        // My Order
        _buildMyOrder(context).sliverBox,

        // 按钮列表
        _buildButtonsList(context).sliverBox,

        // 注销
        ButtonWidget.primary(
              LocaleKeys.myBtnLogout.tr,
              // height: 60,
              // onTap: () => controller.onLogout(),
            )
            .padding(
              left: AppSpace.page,
              right: AppSpace.page,
              bottom: AppSpace.listRow * 2,
            )
            .sliverBox,

        // 版权
        const TextWidget.label(
          "Code by: https://ducafefcat.com",
        ).alignCenter().paddingBottom(AppSpace.listRow).sliverBox,

        // 版本号
        TextWidget.label(
          "v ${ConfigService.to.version}",
        ).alignCenter().paddingBottom(200).sliverBox,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: MyIndexController(),
      id: "my_index",
      builder: (_) {
        return _buildView(context);
      },
    );
  }

  // 列表项
  Widget _buildListItem({
    required String txtTitle,
    required String svgPath,
    Function()? onTap,
  }) {
    // 随机颜色
    Color? iconColor;
    iconColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    // 列表项
    return ListTileWidget(
      title: TextWidget.label(txtTitle),
      leading: IconWidget.svg(svgPath, size: 18, color: Colors.white)
          .paddingAll(6)
          .decorated(color: iconColor, borderRadius: BorderRadius.circular(30)),
      trailing: const <Widget>[IconWidget.icon(Icons.arrow_forward_ios)],
      onTap: onTap,
    ).height(50);
  }
}
