import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common/index.dart';
import 'index.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ChatViewGetX();
  }
}

class _ChatViewGetX extends GetView<ChatController> {
  _ChatViewGetX({Key? key}) : super(key: key);

  /// 用户的 uid 作为唯一标识
  final String uniqueTag = Get.arguments?["uid"]!;

  /// 聊天类型 1: 单聊 2: 群聊
  final type = int.tryParse(Get.arguments['type'].toString());
  // override tag
  @override
  String? get tag => uniqueTag;
  // 主视图
  Widget _buildView() {
    return _buildMsgList().paddingAll(AppSpace.listView).onTap(() {
      controller.onCloseChatBar();
    });
  }

  // 消息列表
  Widget _buildMsgList() {
    return GetBuilder<ChatController>(
      id: "messageList",
      tag: tag,
      builder: (_) {
        var messageList = controller.messageList;
        // messageList 按 timestamp 时间戳 倒序
        messageList.sort((left, right) {
          final rightTimestamp = right.timestamp ?? 0;
          final leftTimestamp = left.timestamp ?? 0;
          return rightTimestamp.compareTo(leftTimestamp);
        });

        return SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: true,
          enablePullDown: false,
          onLoading: controller.onLoading,
          footer: const ClassicFooter(
            loadingIcon: SizedBox(
              width: 25.0,
              height: 25.0,
              child: CupertinoActivityIndicator(),
            ),
          ),
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: messageList.length,
            reverse: true,
            itemBuilder: (context, index) {
              V2TimMessage msg = messageList[index];
              return _buildMsgItem(msg, isSelf: msg.isSelf!);
            },
          ),
        ).paddingAll(AppSpace.listView).onTap(controller.onCloseChatBar);
      },
    );
  }

  // 消息行
  Widget _buildMsgItem(V2TimMessage msg, {bool isSelf = false}) {
    var ws = <Widget>[
      // 头像
      if (isSelf)
        AvatarWidget.asset(
          AssetsImages.logoPng,
          size: Size.copy(
            Size(40, 40),
            //"${Constants.imageServer}/avatar/${UserService.to.profile.avatar}",
          ),
          //"${Constants.imageServer}/avatar/${UserService.to.profile.avatar}",
        ),
      if (isSelf == false)
        msg.faceUrl == null
            ? InitialsWidget(msg.sender!)
            : AvatarWidget.asset(AssetsImages.logoPng),
      // AvatarWidget(
      //   msg.faceUrl!),

      // 内容：昵称、文字、图片
      <Widget>[
            // 昵称
            // if (isSelf == false && controller.isGroup == true)
              TextWidget.body(
                msg.sender ?? "昵称",
                color: AppColors.onPrimaryContainer.withOpacity(0.5),
              ).paddingHorizontal(10),

            // 01: 文字消息
            if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT)
              BubbleWidget(
                text: msg.textElem!.text!,
                isSender: isSelf,
                color: isSelf == true ? AppColors.primary : AppColors.secondary,
                textStyle:
                    isSelf == true
                        ? TextStyle(color: AppColors.onPrimary, fontSize: 16)
                        : TextStyle(color: AppColors.onPrimary, fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(
        receiver: uniqueTag,
        type: type ?? ConversationType.V2TIM_C2C,
      ),
      id: "chat",
      tag: tag,
      builder: (_) {
        return Scaffold(
          // 顶部导航栏
          appBar: AppBar(
            title: Text(controller.title),
            actions: const [
              IconButton(
                icon: Icon(Icons.more_horiz_outlined),
                onPressed: null,
              ),
            ],
          ),
          // 背景色
          backgroundColor: AppColors.surfaceVariant,

          body: SafeArea(child: _buildView()),

          // 底部聊天栏
          bottomNavigationBar: ChatBarWidget(
            key: controller.chatBarKey,
            onTextSend: controller.onTextSend,   
              // 发送语音
            onSoundSend: (path, seconds) {
              
            }, 
            //   发送图片
            onImageSend: (p0) {
              
            },
          ),
        );
      },
    );
  }
}
