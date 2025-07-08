// ignore_for_file: use_build_context_synchronously

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../index.dart';

// 视频配置，秒
const videoDurationMin = 6;
const videoDurationMax = 900;

/// picker 选取器
class ActionPicker {
  /// 相册 assets 权限
  static Future<PrivilegeStatus> assetsPrivilege(BuildContext context) async {
    var privilege = await Privilege.photos();
    if (!privilege.result) {
      await DialogWidget.show(
        context: context,
        content: Text(privilege.message),
        confirm: const Text('Setting'),
        cancel: const Text('Not allowed'),
        onConfirm: () => Privilege.openSettings(),
      );
      return PrivilegeStatus(result: false, message: "");
    }
    return privilege;
  }

  /// 相册 assets 权限
  static Future<List<AssetEntity>?> assets({
    required BuildContext context,
    List<AssetEntity>? selected,
    RequestType type = RequestType.image,
    int maxAssets = 9,
    SpecialPickerType? specialPickerType,
    Widget? Function(BuildContext, AssetPathEntity?, int)? specialItemBuilder,
    SpecialItemPosition specialItemPosition = SpecialItemPosition.none,
  }) async {
    var result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selected,
        requestType: type,
        maxAssets: maxAssets,
        themeColor: context.colors.scheme.surface,
        specialPickerType: specialPickerType,
        filterOptions: FilterOptionGroup(
          orders: [const OrderOption(type: OrderOptionType.createDate)],
          videoOption: const FilterOption(
            durationConstraint: DurationConstraint(
              min: Duration(seconds: videoDurationMin),
              max: Duration(seconds: videoDurationMax),
            ),
          ),
        ),
        specialItemPosition: specialItemPosition,
        specialItemBuilder: specialItemBuilder,
      ),
    );
    return result;
  }

  /// 相机 权限
  static Future<PrivilegeStatus> cameraPrivilege(BuildContext context) async {
    var privilege = await Privilege.camera();
    if (!privilege.result) {
      await DialogWidget.show(
        context: context,
        content: Text(privilege.message),
        confirm: const Text('Setting'),
        cancel: const Text('Not allowed'),
        onConfirm: () => Privilege.openSettings(),
      );
      return PrivilegeStatus(result: false, message: "");
    }
    return privilege;
  }

  /// 相机
  static Future<AssetEntity?> camera({
    required BuildContext context,
    bool enableRecording = true,
  }) async {
    var result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        enableRecording: enableRecording,
        enableAudio: enableRecording,
        textDelegate:
            enableRecording ? const EnglishCameraPickerTextDelegate() : null,
        resolutionPreset: ResolutionPreset.veryHigh,
      ),
    );
    return result;
  }
}
