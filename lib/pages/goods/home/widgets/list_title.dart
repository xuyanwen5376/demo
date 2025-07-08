import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../../common/index.dart';

/// 列表标题
class BuildListTitle extends StatelessWidget {
  /// 标题
  final String title;

  /// 次标题
  final String? subTitle;

  /// 更多点击事件
  final Function()? onTap;

  const BuildListTitle(
      {super.key, required this.title, this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 标题
      TextWidget.h4(
        title,
      ),

      // 子标题
      TextWidget.label(
        subTitle ?? "",
        color: context.colors.scheme.primary,
      ).paddingLeft(AppSpace.listItem).expanded(),

      // ALL
      <Widget>[
        TextWidget.label(
          LocaleKeys.gHomeMore.tr,
        ),
        const IconWidget.icon(Icons.chevron_right),
      ]
          .toRow(
            mainAxisSize: MainAxisSize.min,
          )
          .onTap(onTap),
    ].toRow();
  }
}
