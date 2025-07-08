import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// 顶部导航栏
class PostAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const PostAppBarWidget({
    super.key,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.title,
    this.isAnimated,
    this.isShow,
  });

  /// 此属性控制应用栏下方阴影的大小 [shadowColor] 不为空。
  final double? elevation;

  /// 用于应用栏 [材质] 的填充颜色。
  final Color? backgroundColor;

  /// 在工具栏的 [title] 之前显示的小部件。
  final Widget? leading;

  /// 在 [title] 小部件之后显示在一行中的小部件列表。
  final List<Widget>? actions;

  /// 是否动画
  final bool? isAnimated;

  /// 是否显示
  final bool? isShow;

  /// 标题
  final Widget? title;

  @override
  Size get preferredSize => const Size.fromHeight(30);

  Widget _mainView() {
    var appBar = AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      leading: leading,
      actions: actions,
      title: title,
    );
    return isAnimated == true
        ? isShow == true
            ? FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: appBar,
              )
            : FadeOutUp(
                duration: const Duration(milliseconds: 300),
                child: appBar,
              )
        : appBar;
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
