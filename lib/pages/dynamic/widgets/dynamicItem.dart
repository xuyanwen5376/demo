import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart'; 

/// 商品展示项
class DynamicitemWidget extends StatelessWidget {
  /// 商品数据模型
  final TimelineModel item;

  const DynamicitemWidget(this.item, {super.key});

  Widget _buildView(BuildContext context, BoxConstraints constraints) {
    var ws = <Widget>[
      // 正文、图片、视频
      _buildContent(),

      // 点赞列表
      _buildLikeList(),

      // 评论列表
      _buildCommentList(),
    ];

    return ws
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .backgroundColor(context.colors.scheme.background)
        .elevation(0.1)
        .paddingAll(2)
        .onTap(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildView(context, constraints);
      },
    );
  }

  // 跳转相册
  void _onGallery({String? src, TimelineModel? item}) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) {
          return GalleryWidget(
            initialIndex: src == null ? 1 : item?.images?.indexOf(src) ?? 1,
            timeline: item,
            imgUrls: item?.images ?? [],
          );
        },
      ),
    );
  }

  // 正文、图片、视频
  Widget _buildContent() {
    GlobalKey key = GlobalKey();
    int imgCount = item.images?.length ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 圆角头像
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpace.appbar),
          child: Image.network(
            item.user?.avatar ?? "",
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: AppSpace.listView),

        // 右侧
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 昵称
              Text(
                item.user?.nickName ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SpaceVerticalWidget(),

              // 内容
              // Text 超过2行显示展开按钮
              // TextWidget.label(
              //   item.content ?? "",
              //   // maxLines: 0,
              //   // overflow: TextOverflow.ellipsis,
              //   size: 14,
              //   color: Colors.black87,
              // ),
              TextMaxLinesWidget(content: item.content ?? "", maxLines: 2),
              const SpaceVerticalWidget(),

              // 视频
              if (item.postType == "2")
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double ingWidth = constraints.maxWidth * 0.7;
                    return GestureDetector(
                      onTap: () {
                        _onGallery(item: item);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 图
                          Image.network(
                            DuTools.imageUrlFormat(
                              item.video?.cover ?? "",
                              width: 400,
                            ),
                            height: ingWidth,
                            width: ingWidth,
                            fit: BoxFit.cover,
                          ),
                          // 播放图标
                          const Positioned(
                            child: Icon(
                              Icons.play_circle_fill_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // 9宫格图片
              if (item.postType == "1")
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double ingWidth =
                        imgCount == 1
                            ? constraints.maxWidth * 0.7
                            : (constraints.maxWidth -
                                    AppSpace.appbar * 2 -
                                    AppSpace.appbar * 2 * 3) /
                                3;
                    return Wrap(
                      spacing: AppSpace.appbar,
                      runSpacing: AppSpace.appbar,
                      children: [
                        for (var src in item.images ?? [])
                          GestureDetector(
                            onTap: () {
                              _onGallery(src: src, item: item);
                            },
                            child: Image.network(
                              DuTools.imageUrlFormat(
                                src ?? "",
                                width: imgCount == 1 ? 400 : null,
                              ),
                              height: ingWidth,
                              width: ingWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              const SpaceVerticalWidget(),

              // 位置
              Text(
                item.location ?? "",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SpaceVerticalWidget(),

              // 时间、弹出菜单
              Row(
                children: [
                  // 时间
                  Text(
                    item.publishDate ?? "",
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const Spacer(),

                  // 更多按钮
                  GestureDetector(
                    onTap: () {
                      // // 获取组件屏幕位置
                      // var offset = _getOffset(key);
                      // setState(() {
                      //   _btnOffset = offset;
                      //   _currentItem = item;
                      // });

                      // // 通过 Overlay 显示菜单
                      // _onShowMenu(onTap: () => _onCloseMenu());
                    },
                    child: Container(
                      key: key, // GlobalKey 查询位置
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: const Icon(Icons.more_horiz_outlined),
                    ),
                  ),
                ],
              ),

              // 底部间隙
              const SpaceVerticalWidget(space: 20),
            ],
          ),
        ),
      ],
    );
  }

  // 点赞列表
  Widget _buildLikeList() {
    return Container(
      padding: EdgeInsets.all(AppSpace.listItem),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标
          Padding(
            padding: EdgeInsets.only(top: AppSpace.listItem),
            child: Icon(
              Icons.favorite_border_outlined,
              size: 20,
              color: Colors.black54,
            ),
          ),
          const SpaceHorizontalWidget(),
          // 列表
          Expanded(
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                for (LikeModel item in item.likes ?? [])
                  Image.network(
                    item.avator ?? "",
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 评论列表
  Widget _buildCommentList() {
    return Container(
      padding: EdgeInsets.all(AppSpace.appbar),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标
          Padding(
            padding: EdgeInsets.only(top: AppSpace.appbar),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 20,
              color: Colors.black54,
            ),
          ),
          const SpaceHorizontalWidget(),

          // 右侧评论列表
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (CommentModel comment in item.comments ?? [])
                  // 评论项目
                  Row(
                    children: [
                      // 头像
                      Image.network(
                        comment.user?.avatar ?? "",
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                      const SpaceHorizontalWidget(),

                      // 昵称、时间、内容
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 行 1 昵称、时间
                            Row(
                              children: [
                                // 昵称
                                Text(
                                  comment.user?.nickName ?? "",
                                  style: textStyleComment,
                                ),
                                const Spacer(),
                                // 时间
                                Text(
                                  DuTools.dateTimeFormat(
                                    comment.publishDate ?? "",
                                  ),
                                  style: textStyleComment,
                                ),
                              ],
                            ),
                            // 行 2 内容
                            Text(
                              comment.content ?? "",
                              style: textStyleComment,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // // 底部弹出评论栏
  // Widget _buildCommentBar (BuildContext context) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 100),
  //     padding: MediaQuery.of(context).viewInsets,
  //     child: SafeArea(
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(color: Colors.grey[100]),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // 评论输入框
  //             Row(
  //               children: [
  //                 // 输入框
  //                 Expanded(
  //                   child: TextField(
  //                     controller: _textCommentEditingController,
  //                     focusNode: _focusNode,
  //                     keyboardType: TextInputType.text,
  //                     textInputAction: TextInputAction.done,
  //                     decoration: InputDecoration(
  //                       hintText: "评论",
  //                       // 圆角边框
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         horizontal: 10,
  //                         vertical: 0,
  //                       ),
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       hintStyle: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black26,
  //                         letterSpacing: 2,
  //                       ),
  //                     ),
  //                     // 输入框最大行数
  //                     maxLines: 1,
  //                     // 输入框最小行数
  //                     minLines: 1,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                 ),
  //                 const SpaceHorizontalWidget(),

  //                 // 表情图标
  //                 GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       _isShowEmoji = !_isShowEmoji;
  //                     });
  //                     if (_isShowEmoji) {
  //                       // 收起键盘
  //                       _focusNode.unfocus();
  //                     } else {
  //                       // 获取焦点
  //                       _focusNode.requestFocus();
  //                     }
  //                   },
  //                   child: Icon(
  //                     _isShowEmoji
  //                         ? Icons.keyboard_alt_outlined
  //                         : Icons.mood_outlined,
  //                     size: 32,
  //                     color: Colors.black54,
  //                   ),
  //                 ),
  //                 const SpaceHorizontalWidget(),

  //                 // 发送按钮
  //                 ElevatedButton(
  //                   onPressed: !_isInputWords ? null : _onComment,
  //                   child: const Text("发送", style: TextStyle(fontSize: 16)),
  //                 ),
  //               ],
  //             ),

  //             // 微信表情列表
  //             if (_isShowEmoji)
  //               Container(
  //                 padding: const EdgeInsets.all(spacing),
  //                 height: _keyboardHeight,
  //                 child: GridView.builder(
  //                   gridDelegate:
  //                       const SliverGridDelegateWithFixedCrossAxisCount(
  //                         // 横轴上的组件数量
  //                         crossAxisCount: 7,
  //                         // 沿主轴的组件之间的逻辑像素数。
  //                         mainAxisSpacing: 10,
  //                         // 沿横轴的组件之间的逻辑像素数。
  //                         crossAxisSpacing: 10,
  //                       ),
  //                   itemCount: 100,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return Container(color: Colors.grey[200]);
  //                   },
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
