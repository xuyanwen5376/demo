import 'package:flutter/material.dart';

/// 菜单项 model
class MenuItemModel {
  MenuItemModel({this.icon, this.title, this.right, this.onTap});

  /// 图标
  final IconData? icon;

  /// 标题
  final String? title;

  /// 点击
  final Function()? onTap;

  /// 右侧内容
  final String? right;
}
