import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

class ReportView extends GetView<MineController> {
  const ReportView({super.key});

  Widget _buildView(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        // LineItem item = CartService.to.lineItems[index];
        return ListTile(
          title: TextWidget(text: "标题"),
          subtitle: TextWidget(text: "副标题"),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AppSpace.listRow);
      },
      itemCount: 10, // CartService.to.lineItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      id: "report_view",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
