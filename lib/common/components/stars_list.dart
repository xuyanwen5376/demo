import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../index.dart';

/// 星级列表组件
class StarsListWidget extends StatelessWidget {
  /// 点击事件
  final Function(int value)? onTap;

  /// 图标 data
  final IconData? iconData;

  /// 星级数量
  final int starNum;

  /// 选中的星级
  final int value;

  /// 星级大小
  final double? size;

  // 颜色
  final Color? color;

  // 选中颜色
  final Color? selectedColor;

  // 元素间距
  final double? spacing;

  // 行间距
  final double? runSpacing;

  // 构造
  const StarsListWidget({
    super.key,
    this.onTap,
    this.size = 24,
    this.iconData,
    this.color,
    this.selectedColor,
    this.spacing = 5,
    this.runSpacing = 5,
    this.starNum = 5,
    this.value = 0,
  });

  @override
  Widget build(BuildContext context) {
    Color itemColor = color ?? context.colors.scheme.surfaceContainerHighest;
    Color itemSelectedColor = selectedColor ?? context.colors.scheme.primary;
    List<Widget> ws = [];
    for (var i = 1; i <= starNum; i++) {
      Widget item = IconWidget.icon(
        iconData ?? Icons.star,
        size: size ?? 12,
        color: i <= value ? itemSelectedColor : itemColor,
      );
      item = item.onTap(() {
        if (value == 1 && i == value) {
          onTap?.call(0);
        } else {
          onTap?.call(i);
        }
      });
      ws.add(item);
    }

    return ws.toWrap(
      spacing: spacing ?? AppSpace.listItem,
      runSpacing: runSpacing ?? AppSpace.listRow,
    );
  }
}
