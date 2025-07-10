import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../common/index.dart';
import 'index.dart';

class TiktokPage extends StatefulWidget {
  const TiktokPage({Key? key}) : super(key: key);

  @override
  State<TiktokPage> createState() => _TiktokPageState();
}

class _TiktokPageState extends State<TiktokPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _TiktokViewGetX();
  }
}

class _TiktokViewGetX extends GetView<TiktokController> {
  _TiktokViewGetX({Key? key}) : super(key: key);

  // 快讯
  Widget _buildView() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.mediaList.length,
      onPageChanged: controller.onPageChanged,
      itemBuilder: (context, index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.onInitController(index);
        });
        final item = controller.mediaList[index];
        Widget mediaWidget;
        if (item.type == MediaType.video) {
          final videoController = controller.controllers[index];
          if (videoController == null || !videoController.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          // 适配视频高度，避开底部tabbar
          final screenHeight = MediaQuery.of(context).size.height;
          final tabBarHeight = kBottomNavigationBarHeight; // Flutter内置为56
          final videoHeight = screenHeight - tabBarHeight;
          mediaWidget = Center(
            child: SizedBox(
              width:
                  videoController.value.size.width > 0
                      ? videoController.value.size.width
                      : 1,
              height: videoHeight,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width:
                      videoController.value.size.width > 0
                          ? videoController.value.size.width
                          : 1,
                  height:
                      videoController.value.size.height > 0
                          ? videoController.value.size.height
                          : 1,
                  child: VideoPlayer(videoController),
                ),
              ),
            ),
          );
        } else {
          // 图片高度同样适配
          final screenHeight = MediaQuery.of(context).size.height;
          final tabBarHeight = kBottomNavigationBarHeight;
          final imageHeight = screenHeight - tabBarHeight;
          mediaWidget = Center(
            child: SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Image.network(
                item.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
          );
        }
        return Stack(
          children: [
            mediaWidget,
            Positioned(
              bottom: 80,
              right: 16,
              child:
                  <Widget>[
                    // 收藏
                    Icon(
                      Icons.bookmark_border,
                      color: const Color.fromARGB(255, 237, 168, 168),
                    ),
                    SizedBox(height: 12),
                    // 转发
                    Icon(Icons.share, color: Colors.white),
                  ].toColumn(),
            ),
            // 描述
            Positioned(
              bottom: 28,
              left: 16,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 58, // 屏幕宽度-左右padding
                child:
                    <Widget>[
                          TextWidget.h3(
                            "时代变迁的洪流中，如何获得内心的平静？我的答案是成长",
                            color: Colors.white,
                          ),
                          SizedBox(height: 30),
                          TextWidget.h4(
                            "2023 年，我的生活发生了一些变化。",
                            color: Colors.white,
                          ),
                          TextWidget.label("8月14日 19:00", color: Colors.white),
                          SizedBox(height: 20),
                          TextWidget.label(
                            "代变迁的洪流中，如何获得内心的平静？我代变迁的洪流中，如何获得内心的平静？我代变迁的洪流中，如何获得内心的平静？我代变迁的洪流中，如何获得内心的平静？我代变迁的洪流中，如何获得内心的平静？我时代变迁的洪流中，如何获得内心的平静？我的答案是成长",
                            color: Colors.white,
                          ),
                        ]
                        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                        .paddingAll(AppSpace.listItem)
                        .alignLeft(),
              ),
            ),
          ],
        );
      },
    );
  }

  // 研报
  Widget _buildReportView() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ), // Add horizontal padding here
      itemCount: controller.reportList.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        return _buildReportItem(controller.reportList[index]);
      },
    );
  }

  // 研报item
  Widget _buildReportItem(ReportViewItem item) {
    return Container(
      color: Colors.white,
      child: <Widget>[
            ImageWidget.img(item.url, fit: BoxFit.cover)
                .paddingAll(AppSpace.listItem)
                .tight(width: double.infinity, height: 200),
            <Widget>[TextWidget.h4(item.title), TextWidget.muted(item.date)]
                .toRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )
                .paddingHorizontal(AppSpace.listItem),

            <Widget>[
                  TextWidget.label(item.desc),
                  SizedBox(height: 10),
                  TextWidget.muted('阅读数：' + item.readCount),
                ]
                .toColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )
                .paddingHorizontal(AppSpace.listItem),
          ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(8)
          .elevation(
            AppElevation.listTile,
            borderRadius: BorderRadius.circular(AppRadius.listTile),
            shadowColor: Colors.grey.withOpacity(0.1),
          ),
    );
  }

  // 顶部按钮
  Widget _buildTopButtons() {
    return Container(
      // 背景半透明
      color: Colors.transparent.withOpacity(0.2),
      height: 120,
      child: <Widget>[
            // 快讯
            ButtonWidget.ghost(
              // 背景透明
              backgroundColor: Colors.transparent,
              LocaleKeys.tiktokBtnNews.tr,
              textColor: controller.isNews ? Colors.white : Colors.grey,
              textWeight: FontWeight.w700,
              scale: WidgetScale.large,
              onTap: () {
                controller.onSwitchNews("news");
              },
            ).expanded(),

            // 间距
            SizedBox(width: AppSpace.iconTextLarge),

            // 研报
            ButtonWidget.ghost(
              backgroundColor: Colors.transparent,
              LocaleKeys.tiktokBtnReport.tr,
              textColor: !controller.isNews ? Colors.white : Colors.grey,
              textWeight: FontWeight.w700,
              scale: WidgetScale.large,
              onTap: () {
                controller.onSwitchNews("report");
              },
            ).expanded(),
          ]
          .toRow(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
          .paddingTop(50)
          .paddingHorizontal(AppSpace.page)
          .paddingVertical(AppSpace.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TiktokController>(
      init: TiktokController(),
      id: "tiktok",
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            top: false, // 关键
            bottom: true,
            child: Stack(
              children: [
                if (controller.isNews) _buildView() else _buildReportView(),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopButtons(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
