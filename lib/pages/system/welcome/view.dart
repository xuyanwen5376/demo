import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  /// 轮播图
  Widget _buildSlider() {
    return GetBuilder<WelcomeController>(
      id: "slider",
      init: controller,
      builder:
          (controller) =>
              controller.items == null
                  ? const SizedBox()
                  : WelcomeSliderWidget(
                    controller.items!,
                    onPageChanged: controller.onPageChanged,
                    carouselController: controller.carouselController,
                  ),
    );
  }

  /// 控制栏
  Widget _buildBar() {
    return GetBuilder<WelcomeController>(
      id: "bar",
      init: controller,
      builder: (controller) {
        return controller.isShowStart
            ?
            // 开始
            ButtonWidget.primary(
              LocaleKeys.welcomeStart.tr,
              onTap: controller.onToMain,
            ).tight(width: double.infinity)
            : <Widget>[
              // 跳过
              ButtonWidget.ghost(
                LocaleKeys.welcomeSkip.tr,
                onTap: controller.onToMain,
              ),
              // 指示标
              SliderIndicatorWidget(
                length: 3,
                currentIndex: controller.currentIndex,
              ),
              // 下一页
              ButtonWidget.ghost(
                LocaleKeys.welcomeNext.tr,
                onTap: controller.onNext,
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[_buildSlider(), _buildBar()]
        .toColumn(mainAxisAlignment: MainAxisAlignment.center)
        .paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
      init: WelcomeController(),
      id: "welcome",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("welcome")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
