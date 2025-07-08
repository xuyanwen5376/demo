import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../common/index.dart';

class PostController extends GetxController {
  PostController();

  // 内容输入控制器
  final TextEditingController contentController = TextEditingController();

  List<AssetEntity> selectedAssets = [];

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isWillRemove = false;

  _initData() {
    update(["post"]);
  }

  // 更新选中的图片
  void updateSelectedAssets(List<AssetEntity> assets) {
    selectedAssets = assets;
    update(["post"]); // 刷新视图
  }

  // 设置拖拽状态
  void setDragState(bool isDrag) {
    isDragNow = isDrag;
    update(["post"]);
  }

  // 设置删除状态
  void setRemoveState(bool isRemove) {
    isWillRemove = isRemove;
    update(["post"]);
  }

  // 发布
  void post() async {
    if (contentController.text.isEmpty) {
      Loading.toast("请输入内容");
      return;
    }

    // 如果有选中的图片，先上传到OSS
    if (selectedAssets.isNotEmpty) {
      try {
        Loading.show("正在上传图片...");

        final List<String> filePaths = [];
        final List<String> fileKeys = [];

        for (final asset in selectedAssets) {
          final file = await asset.file;
          if (file == null) continue;
          filePaths.add(file.path);
          fileKeys.add(
            'post_images/${DateTime.now().millisecondsSinceEpoch}_${asset.title ?? 'image'}',
          );
        }

        final urls = await ClientSeivice.to.batchUploadAndGetUrls(
          filePaths,
          fileKeys: fileKeys,
        );

        Loading.dismiss();
        print('所有图片url: $urls');

        // TODO: 这里可以将图片URL和内容一起提交到后端
        Loading.toast("发布成功！图片已上传");
      } catch (e) {
        Loading.dismiss();
        Loading.toast("图片上传失败: $e");
        print('图片上传错误: $e');
      }
    } else {
      // 没有图片，直接发布内容
      Loading.toast("发布成功！");
    }
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();

    ClientSeivice.to.init();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
