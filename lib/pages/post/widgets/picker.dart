import 'package:flutter/material.dart'; 
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/index.dart';
 

// 选取器
class DuPicker {
  /// 底部弹出视图
  static Future<T?> showModalSheet<T>(BuildContext context, {Widget? child}) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: child,
        );
      },
    );
  }

  /// 相册
  static Future<List<AssetEntity>?> assets({
    required BuildContext context,
    List<AssetEntity>? selectedAssets,
    int maxAssets = Constants.maxAssets,
    RequestType requestType = RequestType.image, // 默认图片
  }) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          // 已选中的资源
          selectedAssets: selectedAssets,
          // 选择类型
          requestType: requestType,
          // 资源选择的最大数量
          maxAssets: maxAssets,
          // 构建默认选项组。
          filterOptions: FilterOptionGroup(
            // 视频选项
            videoOption: FilterOption(
              // 视频最大时长
              durationConstraint: requestType == RequestType.video
                  ? DurationConstraint(
                      max: Duration(seconds: Constants.maxVideoDuration.toInt()),
                    )
                  : const DurationConstraint(),
            ),
          )),
    );
    return result;
  }

  /// 拍摄照片
  // static Future<AssetEntity?> takePhoto(BuildContext context) async {
  //   final result = await Navigator.of(context)
  //       .push<AssetEntity?>(MaterialPageRoute(builder: (context) {
  //     return const CameraPage();
  //   }));
  //   return result;
  // }

  // /// 拍摄视频
  // static Future<AssetEntity?> takeVideo(BuildContext context) async {
  //   final filePath = await Navigator.of(context)
  //       .push<AssetEntity?>(MaterialPageRoute(builder: (context) {
  //     return const CameraPage(
  //       captureMode: CaptureMode.video,
  //       maxVideoDuration: Duration(seconds: 30),
  //     );
  //   }));
  //   return filePath;
  // }

  /// 相机
  /// flutter camera android 13 有问题暂时替换掉
  /// https://github.com/flutter/plugins/pull/6867
  // static Future<AssetEntity?> camera({
  //   required BuildContext context,
  //   bool enableRecording = true,
  // }) async {
  //   // var privilege = await Privilege.camera();
  //   // if (!privilege.result) {
  //   //   return null;
  //   // }
  //   var result = await CameraPicker.pickFromCamera(
  //     context,
  //     pickerConfig: CameraPickerConfig(
  //       enableRecording: enableRecording,
  //       enableAudio: enableRecording,
  //       resolutionPreset: ResolutionPreset.veryHigh,
  //       maximumRecordingDuration: const Duration(seconds: 120),
  //     ),
  //   );
  //   return result;
  // }

  /// 相机
  // static Future<AssetEntity?> camera({
  //   required BuildContext context,
  //   bool enableRecording = true,
  // }) async {
  //   // var privilege = await Privilege.camera();
  //   // if (!privilege.result) {
  //   //   return null;
  //   // }
  //   var result = await CameraPicker.pickFromCamera(
  //     context,
  //     pickerConfig: CameraPickerConfig(
  //       enableRecording: enableRecording,
  //       enableAudio: enableRecording,
  //       resolutionPreset: ResolutionPreset.veryHigh,
  //       maximumRecordingDuration: const Duration(seconds: 120),
  //     ),
  //   );
  //   return result;
  // }
}
