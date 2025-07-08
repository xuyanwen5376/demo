import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/index.dart';
import '../index.dart';

class FilterView extends GetView<SearchFilterController> {
  const FilterView({super.key});

  // 标题栏
  Widget _buildTitle(String title) {
    return TextWidget.label(
      title,
      weight: FontWeight.w600,
    ).paddingBottom(AppSpace.listRow);
  }

  // 价格选择区间
  Widget _buildPriceRange() {
    return GetBuilder<SearchFilterController>(
      id: "filter_price_range",
      builder: (_) {
        return PriceRangeWidget(
          max: 5000,
          min: 0,
          values: controller.priceRange,
          onDragging: controller.onPriceRangeDragging,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 尺寸选择
  Widget _buildSizes(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_sizes",
      builder: (_) {
        return TagsListWidget(
          onTap: controller.onSizeTap,
          itemList: controller.sizes,
          keys: controller.sizeKeys,
          bgSelectedColor: context.colors.scheme.secondary,
          textSelectedColor: context.colors.scheme.onPrimary,
          isCircular: true,
          size: 24,
          textSize: 9,
          textWeight: FontWeight.w400,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 颜色选择
  Widget _buildColors(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_colors",
      builder: (_) {
        return TagsListWidget(
          onTap: controller.onColorTap,
          itemList: controller.colors,
          keys: controller.colorKeys,
          bgSelectedColor: context.colors.scheme.secondary,
          textSelectedColor: context.colors.scheme.onPrimary,
          isCircular: true,
          size: 24,
          textSize: 9,
          textWeight: FontWeight.w400,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 评级选择
  Widget _buildStars(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_stars",
      builder: (_) {
        return StarsListWidget(
          value: controller.starValue,
          onTap: controller.onStarTap,
          selectedColor: context.colors.scheme.secondary,
          size: 18,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 品牌选择
  Widget _buildBrands(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_brands",
      builder: (_) {
        return TagsListWidget(
          onTap: controller.onBrandTap,
          itemList: controller.brands,
          keys: controller.brandKeys,
          bgSelectedColor: context.colors.scheme.secondary,
          textSelectedColor: context.colors.scheme.onSecondary,
          borderRadius: 11,
          height: 17,
          width: 55,
          textSize: 9,
          textWeight: FontWeight.w400,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 性别选择
  Widget _buildGenders(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_genders",
      builder: (_) {
        return TagsListWidget(
          onTap: controller.onGenderTap,
          itemList: controller.genders,
          keys: controller.genderKeys,
          bgSelectedColor: context.colors.scheme.secondary,
          textSelectedColor: context.colors.scheme.onSecondary,
          borderRadius: 11,
          height: 17,
          width: 55,
          textSize: 9,
          textWeight: FontWeight.w400,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 新旧选择
  Widget _buildConditions(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_conditions",
      builder: (_) {
        return TagsListWidget(
          onTap: controller.onConditionTap,
          itemList: controller.conditions,
          keys: controller.conditionKeys,
          bgSelectedColor: context.colors.scheme.secondary,
          textSelectedColor: context.colors.scheme.onSecondary,
          borderRadius: 11,
          height: 17,
          width: 55,
          textSize: 9,
          textWeight: FontWeight.w400,
        ).paddingBottom(AppSpace.listRow * 2);
      },
    );
  }

  // 顶部 关闭
  Widget _buildTopBar(BuildContext context) {
    return <Widget>[
          // 文字
          TextWidget.h4(LocaleKeys.searchFilter.tr),

          // 关闭按钮
          ButtonWidget.icon(
            IconWidget.icon(
              Icons.close,
              size: 15,
              color: context.colors.scheme.secondary,
            ),
            onTap: controller.onFilterCloseTap,
          ),
        ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingBottom(AppSpace.listRow);
  }

  Widget _buildView(BuildContext context) {
    return <Widget>[
          // 顶部
          _buildTopBar(context),

          // 价格
          _buildTitle(LocaleKeys.searchFilterPrice.tr),
          _buildPriceRange(),

          // 尺寸
          _buildTitle(LocaleKeys.searchFilterSize.tr),
          _buildSizes(context),

          // 颜色
          _buildTitle(LocaleKeys.searchFilterColor.tr),
          _buildColors(context),

          // 评级
          _buildTitle(LocaleKeys.searchFilterStars.tr),
          _buildStars(context),

          // 品牌
          _buildTitle(LocaleKeys.searchFilterBrand.tr),
          _buildBrands(context),

          // 性别
          _buildTitle(LocaleKeys.searchFilterGender.tr),
          _buildGenders(context),

          // 新旧
          _buildTitle(LocaleKeys.searchFilterCondition.tr),
          _buildConditions(context),

          const Divider(),

          // 应用按钮
          ButtonWidget.primary(
            LocaleKeys.commonBottomApply.tr,
            onTap: controller.onFilterApplyTap,
          ).width(double.infinity).paddingBottom(AppSpace.page),
          // end
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchFilterController>(
      id: "filter_view",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
