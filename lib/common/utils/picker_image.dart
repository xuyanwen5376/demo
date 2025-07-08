import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../index.dart';

/// 选取图片 view
class PickerImageWidget extends StatelessWidget {
  /// 返回拍摄图片
  final Function(AssetEntity? result)? onTapTake;

  /// 返回相册图片
  final Function(List<AssetEntity>? result)? onTapAlbum;

  const PickerImageWidget({
    super.key,
    this.onTapTake,
    this.onTapAlbum,
  });

  // 主视图
  _buildView(BuildContext context) {
    return <Widget>[
      // 拍照
      ButtonWidget.primary(
        LocaleKeys.pickerTakeCamera.tr,
        icon: IconWidget.icon(
          Icons.photo_camera,
          color: context.colors.scheme.onPrimary,
        ),
        onTap: onTapTake == null
            ? null
            : () async {
                // 相机权限
                var privilege =
                    await ActionPicker.cameraPrivilege(Get.context!);
                if (!privilege.result) {
                  return;
                }

                // 相机拍摄
                var result = await ActionPicker.camera(
                  context: Get.context!,
                  enableRecording: false,
                );
                onTapTake!(result);
                Get.back();
              },
      ).width(double.infinity).paddingBottom(AppSpace.listRow),

      // 相册
      ButtonWidget.secondary(
        LocaleKeys.pickerSelectAlbum.tr,
        icon: IconWidget.icon(
          Icons.photo_library,
          color: context.colors.scheme.onPrimary,
        ),
        onTap: onTapAlbum == null
            ? null
            : () async {
                // 相册权限
                var privilege =
                    await ActionPicker.assetsPrivilege(Get.context!);
                if (!privilege.result) {
                  return;
                }
                // 相册选取
                var result = await ActionPicker.assets(
                  context: Get.context!,
                  type: RequestType.image,
                );
                onTapAlbum!(result);
                Get.back();
              },
      ).width(double.infinity).paddingBottom(AppSpace.listRow),

      // 返回
      ButtonWidget.ghost(
        LocaleKeys.commonBottomCancel.tr,
        onTap: () => Get.back(),
      ),
    ]
        .toColumn(
            // mainAxisSize: MainAxisSize.min,
            )
        .paddingAll(AppSpace.card);
    // .backgroundColor(AppColors.background);
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}
