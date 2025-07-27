import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weichat_test/common/index.dart';

import 'index.dart';

class PersontestPage extends GetView<PersontestController> {
  const PersontestPage({super.key});

  // 老板人格测试
  Widget _buildBoss(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconWidget.icon(Icons.wifi_protected_setup_outlined, size: 60),

          TextWidget.h3('老板人格测试', color: Colors.black),
          SizedBox(height: 10),
          TextWidget.label(
            "通过8个问题了解你的管理风格",
            color: const Color.fromARGB(255, 112, 116, 114),
          ),
          TextWidget.muted(
            "查看你更像哪位知名企业家",
            color: const Color.fromARGB(255, 112, 116, 114),
          ),

          ButtonWidget.primary(
            LocaleKeys.startTest.tr,
            onTap: controller.startTest,
          ).width(double.infinity).paddingBottom(30.w).paddingAll(10),
        ],
      ),
    );
  }

  Widget _buildTitleView() {
    return <Widget>[
      const ImageWidget.img(
        AssetsImages.splashJpg,
        fit: BoxFit.cover,
      ).tight(width: 25, height: 25).paddingLeft(16),

      TextWidget.body('推荐咨询', color: const Color.fromARGB(255, 112, 116, 114)),
    ].toRowSpace();
  }

  // 列表
  Widget _buildList() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          // LineItem item =
          return _buildItem();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: AppSpace.listRow);
        },
        itemCount: 10, // CartService.to.lineItems.length,
      ),
    );
  }

  // 列表项
  Widget _buildItem() {
    return <Widget>[
          <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: TextWidget.muted('政策',color: const Color.fromARGB(255, 8, 108, 11),),
              // color: const Color.fromARGB(255, 10, 116, 13),
            ).decorated(
              color: const Color.fromARGB(255, 162, 216, 164), // 在这里设置背景色
              border: Border.all(color: Colors.grey, width: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            TextWidget.body('政经新闻'),
          ].toRowSpace(space: AppSpace.appbar),
          TextWidget.h4(
            '中央经济工作会议定调2025：稳增长与促改革并重',
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
          TextWidget.muted('会议强调要统筹推进深层改革和高水平开放，为企业发展营造更好的环境'),
          TextWidget.muted('30分钟前'),
        ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        )
        .paddingAll(AppSpace.listItem)
        .decorated(color: Colors.white, borderRadius: BorderRadius.circular(8))
        .gestures(onTap: () {})
        .paddingHorizontal(AppSpace.page)
        .paddingBottom(AppSpace.listRow);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildBoss(context),
      _buildTitleView(),
      _buildList(),
    ].toColumn().paddingTop(10);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersontestController>(
      init: PersontestController(),
      id: "persontest",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("人格测试")),
          body: SafeArea(child: _buildView(context)),
        );
      },
    );
  }
}
