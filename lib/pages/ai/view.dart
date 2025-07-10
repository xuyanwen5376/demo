import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import '../../common/index.dart';
import '../chat/chat/widgets/chat_bar.dart';
import 'index.dart';

class AiPage extends StatefulWidget {
  const AiPage({Key? key}) : super(key: key);

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _AiViewGetX();
  }
}

class _AiViewGetX extends GetView<AiController> {
  _AiViewGetX({Key? key}) : super(key: key);
  // 头像
  Widget _buildAvatar(BuildContext context) {
    return IconWidget.img(AssetsImages.logoPng, size: 40, color: Colors.red);
  }

  // 欢迎语aiDisplayText
  Widget _buildWelcome(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(text: 'HI老板， 我是'),
          TextSpan(text: '博商AI', style: TextStyle(color: Color(0xFFB266FF))),
        ],
      ),
    ).paddingLeft(10);
  }

  // 推荐问题
  Widget _buildRecommendQuestions(BuildContext context) {
    List<Widget> ws = [];
    for (var item in controller.recommendQuestions) {
      ws.add(
        Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:
                  <Widget>[
                    IconWidget.icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: Color(0xFFB266FF),
                    ),
                    TextWidget.body(item),
                  ].toRowSpace(),
            )
            .decorated(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFF5F5F5)),
            )
            .paddingAll(AppSpace.appbar)
            .onTap(() {
              // controller.onTextSend(item);
            }),
      );
    }
    return ws.toColumnSpace(space: AppSpace.appbar);
  }

  /// 消息列表
  Widget _buildMsgList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var item = controller.messageList[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMsgItem(item, isSelf: item.isSelf!),
            ),
            const DividerWidget(),
          ],
        );
      }, childCount: controller.messageList.length),
    );
  }

  // 消息行
  Widget _buildMsgItem(V2TimMessage msg, {bool isSelf = false}) {
    var ws = <Widget>[
      // 头像
      if (isSelf)
        AvatarWidget.asset(AssetsImages.logoPng, size: Size.copy(Size(40, 40))),
      if (isSelf == false)
        msg.faceUrl == null
            ? InitialsWidget(msg.sender!)
            : AvatarWidget.asset(AssetsImages.logoPng),

      // 内容
      <Widget>[
            // 昵称
            // if (isSelf == false && controller.isGroup == true)
            TextWidget.body(
              msg.sender ?? "昵称",
              color: AppColors.onPrimaryContainer.withOpacity(0.5),
            ).paddingHorizontal(10),

            // 01: 文字消息
            if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT)
              MarkdownBubbleWidget(
                text: msg.textElem!.text!,
                isSender: isSelf,
                color: isSelf == true ? Colors.grey.shade200 : Colors.white,
                textStyle:
                    isSelf == true
                        ? TextStyle(color: Colors.grey.shade800, fontSize: 16)
                        : TextStyle(color: Colors.black, fontSize: 16),
                markdownStyleSheet: MarkdownStyleSheet(
                  blockquoteDecoration: BoxDecoration(
                    color: Colors.grey.shade100, // 引用块（思考部分）的背景色
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey.shade200, // 思考部分的边框颜色
                        width: 4.0,
                      ),
                    ),
                  ),
                  blockquotePadding: EdgeInsets.all(8.0),
                  blockquoteAlign: WrapAlignment.start,
                  h4Align: WrapAlignment.start,
                  h4: TextStyle(
                    color: Colors.purple.shade800, // 思考标题的颜色
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            //
          ]
          .toColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isSelf == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
          )
          .expanded(),
    ];

    if (isSelf) {
      ws = ws.reversed.toList();
    }

    return ws
        .toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingBottom(AppSpace.listRow);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        const SizedBox(height: 40).sliverToBoxAdapter(),
        // 头像
        _buildAvatar(context).sliverToBoxAdapter(),

        const SizedBox(height: 24).sliverToBoxAdapter(),

        // 欢迎语
        _buildWelcome(context).sliverToBoxAdapter(),

        const SizedBox(height: 32).sliverToBoxAdapter(),
        // 推荐问题
        _buildRecommendQuestions(context).sliverToBoxAdapter(),

        const SizedBox(height: 32).sliverToBoxAdapter(),

        // AI流式消息打印区
        // _buildAiAnswer(context).sliverToBoxAdapter(),

        /// 消息列表
        _buildMsgList(),

        const SizedBox(height: 80).sliverToBoxAdapter(),

        // _buildAiAnswer(context).sliverToBoxAdapter(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiController>(
      init: AiController(),
      id: "ai",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("博商AI"),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFFF7F7FB),
          body: SafeArea(child: _buildView(context)),

          // 底部聊天栏
          bottomNavigationBar: ChatBarWidget(
            key: controller.chatBarKey,
            onTextSend: controller.onTextSend,
            // 发送语音
            onSoundSend: (path, seconds) {},
            //   发送图片
            onImageSend: (p0) {},
          ),
        );
      },
    );
  }
}
