import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../common/index.dart';
import 'index.dart';
import 'widgets/dynamicItem.dart';

class DynamicPage extends GetView<DynamicController> {
  const DynamicPage({super.key});

  // 顶部
  Widget _buildHeader(BuildContext context) {
    // 屏幕宽度
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // 背景
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.white,
          child: ImageWidget.img(
            controller.user?.cover ?? "",
            fit: BoxFit.cover,
          ),
        ),

        // 昵称、头像
        Positioned(
          right: 8,
          bottom: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 昵称
              Text(
                controller.user?.nickName ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 18,
                  height: 1.8,
                  fontWeight: FontWeight.bold,
                  // 文字阴影
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),

              // 头像
              Image.network(
                controller.user?.avatar ?? "",
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Positioned(
          right: 28,
          bottom:50,
          child: ButtonWidget.secondary(
            "发布动态点击",
            width: 120,
            onTap: () {
              // 跳转到post
              Get.toNamed(RouteNames.post);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    print("构建列表，数据长度: ${controller.items.length}");

    if (controller.items.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text("暂无数据", style: TextStyle(color: Colors.grey)),
        ),
      ).sliverToBoxAdapter();
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var item = controller.items[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DynamicitemWidget(item),
            ),
            const DividerWidget(),
          ],
        );
      }, childCount: controller.items.length),
    );
  }

  // 主视图 
  Widget _mainView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (_isShowInput) {
        //   _onSwitchCommentBar();
        // }
      },
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // 头部
          _buildHeader(context).sliverToBoxAdapter().sliverPaddingHorizontal(0),

          // 数据列表
          _buildList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicController>(
      init: DynamicController(),
      id: "dynamic",
      builder: (_) {
        return <Widget>[_mainView(context).expanded()].toColumn();
      },
    );
  }
}
