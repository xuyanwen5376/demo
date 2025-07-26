import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weichat_test/pages/mine/widgets/news.dart';
import 'package:weichat_test/pages/mine/widgets/quote.dart';
import 'package:weichat_test/pages/mine/widgets/report.dart';
import 'package:weichat_test/pages/mine/widgets/setting_view.dart';

import '../../common/index.dart';
import 'index.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MineViewGetX();
  }
}

class _MineViewGetX extends GetView<MineController> {
  const _MineViewGetX({Key? key}) : super(key: key);

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
      elevation: 0,
      // 标题栏左侧间距
      titleSpacing: AppSpace.listItem,

      // 左侧的消息通知按钮区
      leading: IconWidget.icon(Icons.message_outlined, size: 25),
      // 右侧的设置按钮区
      actions: [
        // 图标
        IconWidget.icon(
          Icons.settings_outlined,
          size: 25,
        ).paddingRight(AppSpace.page).onTap(() {
          // 打开右侧 Drawer
          controller.onFilterOpenTap();
        }),
      ],
    );
  }

  // 用户信息
  Widget _buildUserInfo(BuildContext context) {
    // 头像
    return IconWidget.img(
      AssetsImages.homePlaceholderPng,
      width: 120,
      height: 120,
      isVertical: true,
      text: "许严文",
    ).paddingBottom(AppSpace.bottomView);
  }

  // Tab 栏位
  Widget _buildTabBar(BuildContext context) {
    return GetBuilder<MineController>(
      // tag: tag,
      id: "mine_tab",
      builder: (_) {
        return <Widget>[
              _buildTabBarItem(context, LocaleKeys.myTabNews.tr, 0),
              _buildTabBarItem(context, LocaleKeys.myTabReport.tr, 1),
              _buildTabBarItem(context, LocaleKeys.myTabQuote.tr, 2),
            ]
            .toRowSpace(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
            )
            .paddingBottom(AppSpace.appbar);
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

  // TabView 视图
  Widget _buildTabView(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0.w, 20.w, 0.w),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            // 快讯收藏
            NewsView(),
            // 研报收藏
            ReportView(),
            // 金句收藏
            QuoteView(),
          ],
        ),
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildUserInfo(context),
      // Tab 栏位
      _buildTabBar(context),

      // TabView 视图
      _buildTabView(context),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      init: MineController(),
      id: "mine",
      builder: (_) {
        return Scaffold(
          key: controller.scaffoldKey, // 添加key
          appBar: _buildAppBar(context),
          body: SafeArea(child: _buildView(context)),
          // 右侧弹出 Drawer
          endDrawer: const Drawer(child: SafeArea(child: SettingView())),
        );
      },
    );
  }
}
