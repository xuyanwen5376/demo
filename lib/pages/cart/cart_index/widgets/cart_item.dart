import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

/// 购物车列表项
class CartItem extends StatelessWidget {
    /// 修改数量事件
  final Function(int)? onChangeQuantity;
  
  /// 订单数据
  final LineItem lineItem;

  /// 是否全选
  final bool isSelected;

  /// 选中事件
  final Function(bool?)? onSelect;

  const CartItem({
    super.key,
    required this.lineItem,
    required this.isSelected,
    required this.onSelect,
    required this.onChangeQuantity,
  });

  // 主视图
  Widget _buildView() {
    // 商品
    ProductModel product = lineItem.product!;

    return <Widget>[
      // 单选框 
      CheckboxWidget(
        checked: isSelected,
        onChanged: onSelect,
      ).paddingRight(AppSpace.iconTextSmail),

      // 图片
      ImageWidget.img(
        Convert.aliImageResize(product.images?.first.src ?? "", width: 100.w),
        fit: BoxFit.cover,
        width: 78.w,
        height: 100.w,
        radius: AppRadius.image.w,
      ).paddingRight(AppSpace.iconTextSmail),

      // 标题、金额、数量
      <Widget>[
        // 标题
        TextWidget.body(product.name ?? "").paddingBottom(AppSpace.listRow),

        // 属性 Color
        // if (product.attributes?.isNotEmpty == true)
        //   TextWidget.muted(
        //     "${product.attributes?.first.name} - ${product.attributes?.first.options} ",
        //   ),

        // // 属性 Size
        // if (product.attributes?.length == 2)
        //   TextWidget.muted(
        //     "${product.attributes?[1].name} - ${product.attributes?[1].options} ",
        //   ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List<Widget>.generate(
            (product.attributes?.length ?? 0).clamp(0, 3), // 最多显示3个属性
            (index) => TextWidget.body(
              "${product.attributes?[index].name} - ${product.attributes?[index].options} ",
            ),
          ),
        ),

        // 金额 + 数量
        <Widget>[
          // 金额
          TextWidget.label("\$ ${lineItem.total}").expanded(),

          // 数量
          QuantityWidget(
            quantity: lineItem.quantity ?? 0,
            onChange: (quantity) => onChangeQuantity?.call(quantity),
          ),
          // end
        ].toRow().paddingTop(AppSpace.listRow),

        // end
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),

      // end
    ].toRow();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartIndexController>(
      id: "goods_${lineItem.productId}",
      builder: (controller) {
        return _buildView();
      },
    );
  }
}
