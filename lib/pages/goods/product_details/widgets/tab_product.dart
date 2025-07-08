import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

/// 商品规格
class TabProductView extends GetView<ProductDetailsController> {
  const TabProductView({super.key});

  // 标题
  _buildTitle(String title) {
    return TextWidget.body(
      title,
      weight: FontWeight.w500,
    ).paddingBottom(AppSpace.listRow);
  }

  @override
  Widget build(BuildContext context) {
    return <Widget>[
          // 颜色
          _buildTitle("Color"),
          GetBuilder<ProductDetailsController>(
            id: "product_colors",
            // tag: uniqueTag,
            builder: (_) {
              return TagsListWidget(
                itemList: controller.colors,
                keys: controller.colorKeys,
                size: 33.w,
                onTap: controller.onColorTap,
              ).paddingBottom(AppSpace.listRow * 2);
            },
          ),
          _buildTitle("Size"),
          GetBuilder<ProductDetailsController>(
            id: "product_sizes",
            // tag: uniqueTag,
            builder: (_) {
              return TagsListWidget(
                itemList: controller.sizes,
                keys: controller.sizeKeys,
                size: 33.w,
                onTap: controller.onSizeTap,
              ).paddingBottom(AppSpace.listRow * 2);
            },
          ),
          // 运费说明
          _buildTitle("Shipping Charge"),
          <Widget>[
            // 运费
            const TextWidget.label(
              "\$12.10",
              size: 18,
              weight: FontWeight.bold,
            ).paddingRight(AppSpace.listItem),
            // 说明
            const TextWidget.label("by paperfly shipment"),
          ].toRow(),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingVertical(AppSpace.page);
  }
}
