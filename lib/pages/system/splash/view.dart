import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/index.dart';
import 'index.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  // 主视图
  Widget _buildView() {
    return const ImageWidget.img(
      AssetsImages.splashJpg,
      fit: BoxFit.fill, // 填充整个界面
    );
  }

  // // 主视图
  // Widget _buildView() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       // 文字标题
  //       GetBuilder<SplashController>(
  //         id: "splash_title",
  //         builder: (_) {
  //           return Center(
  //             // child: Text(controller.title),
  //             child: Text("SplashPage - ${ConfigService.to.version}"),
  //           );
  //         },
  //       ),

  //       // 按钮
  //       ElevatedButton(
  //         onPressed: () {
  //           controller.onTap(DateTime.now().microsecondsSinceEpoch);
  //         },
  //         child: const Text("立刻点击"),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      id: "splash",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
