import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../common/index.dart';
import 'index.dart';
import 'widgets/news_header.dart';

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

  // appbar
  AppBar _buildAppBarTitle() {
    return AppBar(
      titleSpacing: AppSpace.listItem,
      leading: IconWidget.icon(Icons.mark_as_unread_sharp, size: 25),
      // 按钮组
      title: <Widget>[
            // 快讯
            ButtonWidget.ghost(
              // 背景透明
              backgroundColor: Colors.transparent,
              LocaleKeys.tiktokBtnNews.tr,
              textColor: controller.isNews ? Colors.black : Colors.grey,
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
              textColor: !controller.isNews ? Colors.black : Colors.grey,
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
          // .paddingTop(50)
          .paddingHorizontal(AppSpace.page)
          .paddingVertical(AppSpace.page),
    );
  }

  // 快讯
  Widget _buildNewsView() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.mediaList.length,
      onPageChanged: controller.onPageChanged,
      itemBuilder: (context, index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.onInitController(index);
        });
        final item = controller.mediaList[index];
        return Stack(
          children: [
            _buildContentItem(context, item).onTap(controller.onTapDetail),

            Positioned(bottom: 10, right: 0, child: _buildOptionItem()),
          ],
        );
      },
    );
  }

  // 内容区域
  Widget _buildContentItem(BuildContext context, MediaItem item) {
    return <Widget>[
          NewsHeaderWidget(
            quote: "数字化转型的本质是用技术重新定义商业模式，创造新的价值增长点。",
            author: "张勇",
            position: "阿里巴巴CEO",
          ).paddingAll(AppSpace.page),

          SizedBox(height: 20),

          TextWidget.h3("科技巨头Q4财报超预期，AI投资持续加码", color: Colors.black),

          ImageWidget.img(
            AssetsImages.homePlaceholderPng,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 140,
          ),
          SizedBox(height: 10),
          TextWidget.label("2小时前", color: Colors.black54),
          SizedBox(height: 20),
          TextWidget.label(
            "多家科技公司发布Q4财报，营收和利润均超市场预期。AI相关业务成为主要增长驱动力其中，AI相关业务成为主要增长驱动力，，各公司纷纷加大AI基础设施投资。分析师认为，这一趋势将在2024年持续，为相关产业链带来新机遇。其中，AI相关业务成为主要增长驱动力其中，AI相关业务成为主要增长驱动力，，各公司纷纷加大AI基础设施投资。分析师认为，这一趋势将在2024年持续，为相关产业链带来新机遇。",
          ).tight(width: MediaQuery.of(context).size.width * 0.8),
        ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingAll(AppSpace.page);
  }

  // 点赞 收藏 ai解读
  Widget _buildOptionItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
      child: <Widget>[
        // 收藏按钮带数字
        Column(
          children: [
            Icon(Icons.star, color: Colors.redAccent, size: 30.w),
            SizedBox(height: 4.w),
            TextWidget.label(
              '888',
              color: Colors.grey,
              weight: FontWeight.w500,
            ),
          ],
        ),

        SizedBox(height: 20.w),

        // AI按钮
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
              child: TextWidget.label(
                'AI',
                color: Colors.redAccent,
                weight: FontWeight.bold,
                size: 16,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.w),

        // 播放按钮
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child:
              IconWidget.icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 22.w,
              ).center(),
        ),

        SizedBox(height: 20.w),

        // 分享按钮
        Icon(Icons.share, color: Colors.grey.shade300, size: 30.w),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
      ),
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
        return _buildReportItem(controller.reportList[index]).onTap(controller.onTapDetail);
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TiktokController>(
      init: TiktokController(),
      id: "tiktok",
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBarTitle(),
          body: SafeArea(
            top: false, // 关键
            bottom: true,
            child: Stack(
              children: [
                if (controller.isNews) _buildNewsView() else _buildReportView(),
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   child: _buildTopButtons(),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
