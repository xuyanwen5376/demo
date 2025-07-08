import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../../common/components/review_item.dart';
import '../../../../common/index.dart';
import '../index.dart';

/// 评论
class TabReviewsView extends GetView<ProductDetailsController> {
  const TabReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var item = controller.reviews[index];
        return ReViewItemWidget(item);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AppSpace.listRow * 2);
      },
      itemCount: controller.reviews.length,
    ).paddingVertical(AppSpace.page);
  }
}
