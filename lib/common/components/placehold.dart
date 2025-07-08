import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../index.dart';

/// 占位图组件
class PlaceholdWidget extends StatelessWidget {
  // 资源图片地址
  final String? assetImagePath;

  const PlaceholdWidget({
    super.key,
    this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ImageWidget.img(assetImagePath ?? AssetsImages.homePlaceholderPng)
        .paddingHorizontal(AppSpace.page)
        .center();
  }
}
