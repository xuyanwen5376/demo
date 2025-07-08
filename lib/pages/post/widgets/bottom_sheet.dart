// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/index.dart';
import 'picker.dart';
 

enum PickType { camera, asset }

/// 微信底部弹出
class DuBottomSheet {
  DuBottomSheet({this.selectedAssets});

  final List<AssetEntity>? selectedAssets;

  /// 选择拍摄、相机资源
  Future<T?> wxPicker<T>(BuildContext context) {
    return DuPicker.showModalSheet<T>(
      context,
      child: _buildAssetCamera(context),
    );
  }

  // 相册、相机
  Widget _buildAssetCamera(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 拍摄
        _buildBtn(
          const Text("拍摄"),
          onTap: () {
            DuPicker.showModalSheet(
              context,
              child: _buildMediaImageVideo(context, pickType: PickType.camera),
            );
          },
        ),
        const DividerWidget(),

        // 相册
        _buildBtn(
          const Text("相册"),
          onTap: () {
            DuPicker.showModalSheet(
              context,
              child: _buildMediaImageVideo(context, pickType: PickType.asset),
            );
          },
        ),
        const DividerWidget(
            size: 6,
        ),

        // 取消
        _buildBtn(
          const Text("取消"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // 图片、视频
  Widget _buildMediaImageVideo(BuildContext context,
      {required PickType pickType}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 图片
        _buildBtn(
          const Text("图片"),
          onTap: () async {
            List<AssetEntity>? result;
            if (pickType == PickType.asset) {
              result = await DuPicker.assets(
                context: context,
                requestType: RequestType.image,
                selectedAssets: selectedAssets,
              );
            }
            //  else if (pickType == PickType.camera) {
            //   final asset = await DuPicker.takePhoto(context);
            //   if (asset == null) {
            //     return;
            //   }
            //   if (selectedAssets == null) {
            //     result = [asset];
            //   } else {
            //     result = [...selectedAssets!, asset];
            //   }
            // }
            _popRoute(context, result: result);
          },
        ),
        const DividerWidget(),

        // 视频
        _buildBtn(
          const Text("视频"),
          onTap: () async {
            List<AssetEntity>? result;
            if (pickType == PickType.asset) {
              result = await DuPicker.assets(
                context: context,
                requestType: RequestType.video,
                selectedAssets: selectedAssets,
                maxAssets: 1,
              );
            } 
            // else if (pickType == PickType.camera) {
            //   final asset = await DuPicker.takeVideo(context);
            //   if (asset == null) {
            //     return;
            //   }
            //   result = [asset];
            // }
            _popRoute(context, result: result);
          },
        ),
        const DividerWidget(size: 6),

        // 取消
        _buildBtn(
          const Text("取消"),
          onTap: () {
            _popRoute(context);
          },
        ),
      ],
    );
  }

  // 返回
  void _popRoute(BuildContext context, {result}) {
    Navigator.pop(context);
    Navigator.pop(context, result);
  }

  // 按钮
  InkWell _buildBtn(Widget child, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        child: child,
      ),
    );
  }
}
