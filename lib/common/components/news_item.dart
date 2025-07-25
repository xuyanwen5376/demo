import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weichat_test/common/models/woo/news_model/news_model.dart';

import '../index.dart';

/// 商品展示项
class NewsItemWidget extends StatelessWidget {
  /// 点击事件
  final Function()? onTap;

  /// 数据模型
  final NewsModel? newsModel;

  /// 图片宽
  final double? imgWidth;

  /// 图片高
  final double? imgHeight;

  const NewsItemWidget(
    this.newsModel, {
    super.key,
    this.onTap,
    this.imgWidth,
    this.imgHeight,
  });

  Widget _buildView(BuildContext context, BoxConstraints constraints) {
    var ws = <Widget>[];

    // 图片
    // if (newsModel.url?.isEmpty = false) {
    //   ws.add(
    //     ImageWidget.img(
    //       product.images?.first.src ?? "",
    //       fit: BoxFit.cover,
    //       width: imgWidth ?? constraints.minWidth,
    //       height: imgHeight,
    //     ),
    //   );
    // } else {
    // 如果没有图片，添加一个占位容器
    ws.add(
      Container(
        width: imgWidth ?? constraints.minWidth,
        height: imgHeight ?? 150.w,
        color: context.colors.scheme.surfaceContainer,
        child:
            Icon(
              Icons.image_not_supported,
              color: context.colors.scheme.outline,
              size: 32,
            ).center(),
      ),
    );
    // }

    // 描述
    // ws.add(
    //   <Widget>[
    //         // 标题
    //         TextWidget.label(
    //           newsModel?.title ?? "",
    //           overflow: TextOverflow.ellipsis,
    //           maxLines: 2,
    //         ),

    //         // 副标题
    //         if (newsModel?.subtitle != null)
    //           TextWidget.label(
    //             newsModel?.subtitle ?? "",
    //             weight: FontWeight.bold,
    //           ),
    //       ]
    //       .toColumn(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //       )
    //       .paddingHorizontal(5)
    //       .expanded(),
    // );

    return ws.toStack();
    //  ws
    //     .toColumn(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //     )
    //     .backgroundColor(context.colors.scheme.onPrimary)
    //     .elevation(0.1)
    //     .paddingAll(2)
    //     .onTap(() {
    //       if (onTap != null) {
    //         onTap?.call();
    //       } else {
    //         //   Get.toNamed(
    //         //     RouteNames.goodsProductDetails,
    //         //     arguments: {"id": product.id},
    //         //   );
    //       }
    //     });
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
