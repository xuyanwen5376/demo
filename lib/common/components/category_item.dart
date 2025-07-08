import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../index.dart';

/// 分类导航项
class CategoryListItemWidget extends StatelessWidget {
  /// 分类数据
  final CategoryModel category;

  /// 选中代码
  final int? selectId;

  /// tap 事件
  final Function(int categoryId)? onTap;

  const CategoryListItemWidget({
    super.key,
    required this.category,
    this.onTap,
    this.selectId,
  });

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 图
      ImageWidget.img(
        category.image?.src ?? "", // 图片地址
        width: 52.w,
        height: 52.w,
      ),
      // 文字
      TextWidget.label(
        category.name ?? "-", // 文字内容
        size: 18.sp,
        color: selectId == category.id
            ? context.colors.scheme.primary
            : null, // 选中颜色
      ),
    ]
        .toColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )

        // padding 垂直间距
        .paddingVertical(AppSpace.button)

        // 背景色
        .backgroundColor(
          selectId == category.id
              ? context.colors.scheme.primaryContainer
              : Colors.transparent,
        )
        .onTap(() => onTap?.call(category.id!));
  }
}
