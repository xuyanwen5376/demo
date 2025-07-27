import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

class QuoteView extends GetView<MineController> {
  const QuoteView({super.key});

  // 列表项
  Widget _buildItem({
    required String content,
    required String userName,
    required String companyName,
    required String? type,
  }) {
    return <Widget>[
          // 内容
          TextWidget.body(content),

          // 用户名
          TextWidget.body(userName),

          // 公司名
          TextWidget.body(companyName),
        ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        )
        .paddingAll(AppSpace.listItem)
        .decorated(color: Colors.white, borderRadius: BorderRadius.circular(8))
        .gestures(onTap: () {})
        .paddingHorizontal(AppSpace.page)
        .paddingBottom(AppSpace.listRow);
  }

  Widget _buildView(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        // LineItem item = CartService.to.lineItems[index];
        return _buildItem(
          content: "在变化的时代，唯一不变的就是变化本身，企业要想生存，必须拥抱变化，主动求变 $index",
          userName: "码云 $index",
          companyName: "阿里巴巴创始人 $index",
          type: "创业 $index",
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AppSpace.listRow);
      },
      itemCount: 10, // CartService.to.lineItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      id: "quote_view",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
