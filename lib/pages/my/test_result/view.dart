import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weichat_test/utils/config.dart';

import '../../../common/index.dart';
import 'index.dart';

class TestResultPage extends GetView<TestResultController> {
  const TestResultPage({super.key});

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      // 头像
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconWidget.img(
          AssetsImages.orderConfirmedPng,
          width: 120,
          height: 120,
          isVertical: true,
        ).paddingBottom(AppSpace.bottomView),
      ),

      TextWidget.h4('测试结果'),

      TextWidget.label('完美主义创作着'),

      TextWidget.label('史蒂夫-乔布斯'),

      TextWidget.label('苹果公司'),

      TextWidget.label(
        '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内内容内容内容内容内容内容内容内容内容内内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
      ).padding(all: 10),
      // 底部按钮
      _buildButtons(),
      // 底部间距
      SizedBox(height: AppSpace.bottomView),
    ].toColumn();
  }

  // 底部按钮
  Widget _buildButtons() {
    return <Widget>[
          ButtonWidget.secondary(
            LocaleKeys.startTest.tr,
            onTap: () {},
          ).expanded(),

          // 间距
          SizedBox(width: AppSpace.iconTextLarge),

          ButtonWidget.primary(LocaleKeys.shareResult.tr).expanded(),
        ]
        .toRow(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
        .paddingHorizontal(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestResultController>(
      init: TestResultController(),
      id: "test_result",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("测试结果")),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
