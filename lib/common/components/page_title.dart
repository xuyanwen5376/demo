import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

// 页面标题 组件
class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
          ImageWidget.img(
            AssetsImages.logoPng,
            width: 100.w,
            height: 100.w,
            fit: BoxFit.cover,
          ),
          TextWidget.h4(LocaleKeys.appName.tr).paddingTop(10.w),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.center)
        .tight(width: double.infinity);
  }
}
