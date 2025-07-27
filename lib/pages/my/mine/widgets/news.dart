import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart'; 
import '../index.dart';

class NewsView extends GetView<MineController> {
  const NewsView({super.key});

  // 快讯收藏
  Widget _buildView(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpace.listRow,
        crossAxisSpacing: AppSpace.listItem,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return NewsItemWidget(controller.items[index], imgHeight: 150.w);
      },
      itemCount: controller.items.length,
      padding: EdgeInsets.all(AppSpace.page),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      id: "news_view",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
