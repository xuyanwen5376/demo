 import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:weichat_test/pages/post/widgets/bottom_sheet.dart';
import '../../../common/index.dart';
import '../../index.dart';
import 'menu.dart';
import 'player.dart';

/// 发布类型
enum PostType { image, video }

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _PostViewGetX();
  }
}

class _PostViewGetX extends GetView<PostController> {
  _PostViewGetX({Key? key}) : super(key: key);
  // 发布类型
  PostType? _postType = PostType.image;

  // 拖拽状态现在在 controller 中管理

  // 是否被拖拽到
  bool _isWillOrder = false;

  // 被拖拽到id
  String _targetAssetId = "";

  // 视频压缩文件
  // ignore: unused_field
  CompressMediaFile? _videoCompressFile;

  // 最大内容长度
  final int _maxContentLength = 500;

  // 菜单项
  List<MenuItemModel> _menus = [
    MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
    MenuItemModel(icon: Icons.alternate_email_outlined, title: "提醒谁看"),
    MenuItemModel(icon: Icons.person_outline, title: "谁可以看", right: "公开"),
  ];

  double spacing = 10;

  double imagePadding = 10;

  double itemW = 100;

  // 内容输入
  Widget _buildContentInput() {
    return LimitedBox(
      maxHeight: 200,
      child: TextField(
        controller: controller.contentController,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        maxLines: null,
        maxLength: _maxContentLength,
        decoration: InputDecoration(
          hintText: '这一刻的想法...',
          hintStyle: const TextStyle(
            color: Colors.black12,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          counterText: controller.contentController.text.isEmpty ? "" : null,
        ),
        onChanged: (value) {
          // setState(() {});
        },
      ),
    );
  }

  // 菜单项目
  Widget _buildMenus() {
    List<Widget> ws = [];
    ws.add(const DividerWidget());
    for (var menu in _menus) {
      ws.add(
        ListTile(
          leading: Icon(menu.icon),
          title: Row(
            children: [
              Text(menu.title ?? ""),
              if (menu.right != null) const Spacer(),
              if (menu.right != null) Text(menu.right!),
            ],
          ),
          trailing: const Icon(Icons.navigate_next_rounded),
          // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          horizontalTitleGap: -5, // 标题与图标间距
        ),
      );
      ws.add(const DividerWidget());
    }
    return Column(children: ws);
  }

  // 图片列表
  Widget _buildPhotosList() {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          itemW =
              (constraints.maxWidth - spacing * 2 - imagePadding * 2 * 3) / 3;
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                // 图片
                for (var item in controller.selectedAssets)
                  _buildPhotoItem(itemW, item),

                // 添加按钮
                if (controller.selectedAssets.length < Constants.maxAssets)
                  _buildAddBtn(context, itemW),
              ],
            ),
          );
        },
      ),
    );
  }

  // 图片项
  Widget _buildPhotoItem(double width, AssetEntity item) {
    // 包裹一个可以拖动到 [DragTarget] 的小部件。
    return Draggable(
      // 此可拖动对象将拖放的数据
      data: item,

      // 当可拖动对象开始被拖动时调用。
      onDragStarted: () {
        controller.setDragState(true);
      },
      // 当可拖动对象被放下时调用。
      onDragEnd: (details) {
        controller.setDragState(false);
      },
      // 当 draggable 被放置并被 [DragTarget] 接受时调用。
      onDragCompleted: () {},

      // 当 draggable 被放置但未被 [DragTarget] 接受时调用。
      onDraggableCanceled: (velocity, offset) {
        controller.setDragState(false);
      },

      // 拖动进行时显示在指针下方的小部件。
      feedback: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
        child: AssetEntityImage(
          item,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
        ),
      ),

      // 当正在进行一个或多个拖动时显示的小部件而不是 [child]。
      childWhenDragging: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
        child: AssetEntityImage(
          item,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
          opacity: const AlwaysStoppedAnimation(0.2), // 透明度
        ),
      ),

      // 子组件, 创建一个接收拖动的小部件。
      child: DragTarget<AssetEntity>(
        // 调用以构建此小部件的内容。
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () => _onGallery(item),
            child: Container(
              padding:
                  (_isWillOrder && _targetAssetId == item.id)
                      ? EdgeInsets.zero
                      : EdgeInsets.all(spacing),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border:
                    (_isWillOrder && _targetAssetId == item.id)
                        ? Border.all(color: Colors.blue, width: imagePadding)
                        : null,
              ),
              child: AssetEntityImage(
                width: width,
                height: width,
                item,
                fit: BoxFit.cover,
                isOriginal: false,
              ),
            ),
          );
        },

        // 调用以确定此小部件是否有兴趣接收给定的 被拖动到这个拖动目标上的数据片段。
        onWillAccept: (data) {
          // 排除自己
          if (data?.id == item.id) {
            return false;
          }
          // setState(() {
          _isWillOrder = true;
          _targetAssetId = item.id;
          // });
          return true;
        },

        // 当一条可接受的数据被拖放到这个拖动目标上时调用。
        onAccept: (data) {
          // 当前元素位置
          int targetIndex = controller.selectedAssets.indexWhere((element) {
            return element.id == item.id;
          });
          // 删除原来的
          controller.selectedAssets.removeWhere((element) {
            return element.id == data.id;
          });
          // 插入到目标前面
          controller.selectedAssets.insert(targetIndex, data);

          // 更新状态
          _isWillOrder = false;
          _targetAssetId = "";
          controller.update(["post"]); // 刷新视图
        },

        // 当被拖动到该目标上的给定数据离开时调用 目标。
        onLeave: (data) {
          // setState(() {
          _isWillOrder = false;
          _targetAssetId = "";
          // });
        },
      ),
    );
  }

  // 添加按钮
  GestureDetector _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        final result = await DuBottomSheet(
          selectedAssets: controller.selectedAssets,
        ).wxPicker<List<AssetEntity>>(context);
        if (result == null || result.isEmpty) return;

        // 视频
        if (result.length == 1 && result.first.type == AssetType.video) {
          // setState(() {
          _postType = PostType.video;
          controller.updateSelectedAssets(result);

          // });
        }
        // 图片
        else {
          // setState(() {
          _postType = PostType.image;
          controller.updateSelectedAssets(result);
          // });
        }
      },
      child: Container(
        margin: EdgeInsets.all(spacing),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(3),
        ),
        width: width,
        height: width,
        child: const Icon(Icons.add, size: 48, color: Colors.black54),
      ),
    );
  }

  // 删除 bar
  Widget _buildRemoveBar() {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return Container(
          color: controller.isWillRemove ? Colors.red[300] : Colors.red[200],
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标
                Icon(
                  Icons.delete,
                  color:
                      controller.isWillRemove ? Colors.white : Colors.white70,
                  size: 32,
                ),
                // 文字
                Text(
                  '拖拽到这里删除',
                  style: TextStyle(
                    color:
                        controller.isWillRemove ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onWillAccept: (AssetEntity? data) {
        controller.setRemoveState(true);
        return true;
      },
      onAccept: (AssetEntity data) {
        controller.selectedAssets.remove(data);
        controller.setRemoveState(false);
        controller.update(["post"]); // 刷新视图
      },
      onLeave: (AssetEntity? data) {
        controller.setRemoveState(false);
      },
    );
  }

  // 主视图
  Widget _mainView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          children: [
            // 内容输入
            _buildContentInput(),

            // 相册列表
            if (_postType == PostType.image) _buildPhotosList(),

            // 视频播放器
            if (_postType == PostType.video)
              VideoPlayerWidget(
                initAsset: controller.selectedAssets.first,
                onCompleted: (value) => _videoCompressFile = value,
              ),

            // 添加按钮
            if (_postType == null && controller.selectedAssets.isEmpty)
              Padding(
                padding: EdgeInsets.all(spacing),
                child: _buildAddBtn(Get.context!, 100),
              ),

            // 菜单
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: _buildMenus(),
            ),
          ],
        ),
      ),
    );
  }

  // 跳转相册
  void _onGallery(item) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) {
          return GalleryWidget(
            initialIndex: controller.selectedAssets.indexOf(item),
            items: controller.selectedAssets,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
      id: "post",
      builder: (_) {
        return Scaffold(
          appBar: PostAppBarWidget(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black38,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: AppSpace.appbar),
                child: ElevatedButton(
                  onPressed: () {
                    controller.post();
                  },
                  child: const Text("发布"),
                ),
              ),
            ],
          ),

          // 要显示的持久底部工作表
          bottomSheet: controller.isDragNow ? _buildRemoveBar() : null,

          body: _mainView(),
        );
      },
    );
  }
}
