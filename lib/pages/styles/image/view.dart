import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';

class ImagePage extends GetView<ImageController> {
  const ImagePage({super.key});
  final imgUrl =
      "https://ducafecat.oss-cn-beijing.aliyuncs.com/podcast/2024/08/36c15e6f46e96d85d56097424df1a26a.png";

  // 主视图
  Widget _buildView(BuildContext context, BoxConstraints constraints) {
    var width = constraints.maxWidth;

    return <Widget>[
      // 本地图片
      const Text("本地图片"),
      const ImageWidget.img(
        AssetsImages.homePlaceholderPng,
        fit: BoxFit.cover,
      ).tight(width: width, height: 200),

      // 远程图片
      const Text("远程图片"),
      ImageWidget.img(
        imgUrl,
        fit: BoxFit.cover,
      ).tight(width: width, height: 200),

      // 本地 svg
      const Text("本地 svg"),
      const ImageWidget.svg(
        AssetsSvgs.cBagSvg,
        fit: BoxFit.cover,
      ).tight(width: width, height: 200),

      // svg raw
      const Text("svg raw"),
      // ImageWidget.svgRaw(
      //   svgRaw,
      //   fit: BoxFit.cover,
      // ).tight(
      //   width: width,
      //   height: 200,
      // ),

      // end
    ].toColumnSpace().scrollable();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageController>(
      init: ImageController(),
      id: "image",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("image")),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return _buildView(
                  context,
                  constraints,
                ).paddingHorizontal(AppSpace.page);
              },
            ),
          ),
        );
      },
    );
  }
}
