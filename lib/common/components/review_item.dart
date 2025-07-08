import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 商品展示项
class ReViewItemWidget extends StatelessWidget {
  /// 点击事件
  final Function()? onTap;

  /// 商品数据模型
  final ReviewModel item;

  /// 图片宽
  final double? imgWidth;

  /// 图片高
  final double? imgHeight;

  const ReViewItemWidget(
    this.item, {
    super.key,
    this.onTap,
    this.imgWidth,
    this.imgHeight,
  });

  // 评论图
  Widget _buildReviewImages() {
    return <Widget>[
      for (var i = 0; i < item.reviewImages!.length; i++)
        ImageWidget.img(item.reviewImages![i], width: 45.w, height: 45.w),
    ].toWrap(spacing: AppSpace.listItem, runSpacing: AppSpace.listRow);
  }

  Widget _buildView(BuildContext context, BoxConstraints constraints) {
    var ws = <Widget>[
          ImageWidget.img(
            // review.reviewerAvatarUrls?["96"],
            "https://ducafecat-pub.oss-cn-qingdao.aliyuncs.com/avatar/00258VC3ly1gty0r05zh2j60ut0u0tce02.jpg",
            width: 45.w,
            height: 45.w,
          ),

          // 星、名称、评论、图
          <Widget>[
            // 星
            IconWidget(
              type: IconWidgetType.icon,
              iconData: Icons.favorite,
              size: 20,
              color: context.colors.scheme.primary,
            ).paddingRight(AppSpace.iconTextMedium),

            <Widget>[
              // 名称
              TextWidget.body(
                item.reviewer ?? "",
                weight: FontWeight.w500,
              ).expanded(),
              // 时间
              TextWidget.label(
                DateTime.parse(item.dateCreated ?? "").toString().split(" ")[0],
              ),
            ].toRow(),
            // 评论
            TextWidget.label(item.review?.clearHtml ?? ""),

            // 图
            _buildReviewImages(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),
        ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .backgroundColor(context.colors.scheme.onPrimary)
        .elevation(0.1)
        .paddingAll(2);

    return ws.onTap(() {
      if (onTap != null) {
        onTap?.call();
      } else {
        Get.toNamed(RouteNames.goodsProductDetails, arguments: {"id": item.id});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildView(context, constraints);
      },
    );
  }
}
