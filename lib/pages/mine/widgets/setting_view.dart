import 'dart:math';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

class SettingView extends GetView<MineController> {
  const SettingView({super.key});

  // 列表项
  Widget _buildListItem({
    required String txtTitle,
    required String svgPath,
    Function()? onTap,
  }) {
    // 随机颜色
    Color? iconColor;
    iconColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    // 列表项
    return ListTileWidget(
      title: TextWidget.label(txtTitle),
      leading: IconWidget.svg(svgPath, size: 18, color: Colors.white)
          .paddingAll(6)
          .decorated(color: iconColor, borderRadius: BorderRadius.circular(30)),
      trailing: const <Widget>[IconWidget.icon(Icons.arrow_forward_ios)],
      onTap: onTap,
    ).height(50);
  }

  Widget _buildView(BuildContext context) {
    return <Widget>[
          // 个人信息
          _buildListItem(
            txtTitle: LocaleKeys.myInfoTitle.tr,
            svgPath: AssetsSvgs.pCurrencySvg,
            onTap: () => Get.toNamed(RouteNames.myProfileEdit),
          ),

          // 历史记录
          _buildListItem(
            txtTitle: LocaleKeys.myHistoryTitle.tr,
            svgPath: AssetsSvgs.pCurrencySvg,
            // onTap: () => Get.toNamed(RouteNames.myProfileEdit),
          ),

          // 语音风格
          _buildListItem(
            txtTitle: LocaleKeys.myVoiceStyleTitle.tr,
            svgPath: AssetsSvgs.pCurrencySvg,
            // onTap: () => Get.toNamed(RouteNames.myProfileEdit),
          ),
          // 测评结果
          _buildListItem(
            txtTitle: LocaleKeys.myTestResultTitle.tr,
            svgPath: AssetsSvgs.pCurrencySvg,
            // onTap: () => Get.toNamed(RouteNames.myProfileEdit),
          ),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      id: "setting_view",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
