import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../pages/index.dart';
import '../../index.dart'; 

/// 群消息类型文字
String getIMGroupTipsTypeString(IMGroupTipsType type, {String? members}) {
  switch (type) {
    case IMGroupTipsType.enter:
      return LocaleKeys.chatGroupTipEnter.trParams({"members": members ?? ""});
    case IMGroupTipsType.invited:
      return LocaleKeys.chatGroupTipInvited.trParams({
        "members": members ?? "",
      });
    case IMGroupTipsType.leave:
      return LocaleKeys.chatGroupTipQuit.trParams({"members": members ?? ""});
    case IMGroupTipsType.kicked:
      return LocaleKeys.chatGroupTipKick.trParams({"members": members ?? ""});
    case IMGroupTipsType.setAdmin:
      return LocaleKeys.chatGroupTipSetAdmin.trParams({
        "members": members ?? "",
      });
    case IMGroupTipsType.cancelAdmin:
      return LocaleKeys.chatGroupTipCancelAdmin.trParams({
        "members": members ?? "",
      });
    case IMGroupTipsType.groupInfoChange:
      return LocaleKeys.chatGroupTipChangeInfo.trParams({
        "members": members ?? "",
      });
    case IMGroupTipsType.memberInfoChange:
      return LocaleKeys.chatGroupTipChangeMemberInfo.trParams({
        "members": members ?? "",
      });
    default:
      return "";
  }
}

/// 显示提示
void showTip(String message) {
  Get.showSnackbar(
    GetSnackBar(message: message, duration: const Duration(seconds: 2)),
  );
}

/// app 内消息提示
void showAppNotice(V2TimMessage data, {bool isInApp = true}) {
  // 内容
  String subtitle = "";
  if (data.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
    subtitle = (data.textElem?.text ?? "").replaceAll(RegExp(r'\n'), "");
  }

  // 聊天类型 1: 单聊 2: 群聊
  int type = data.groupID == null ? 1 : 2;

  // 发送人
  String uid = type == 1 ? data.userID ?? "" : data.groupID ?? "";

  // if (isInApp) {
  //   showSimpleNotification(
  //     ListTile(
  //       onTap: () => onChat(uid, type),
  //       leading: IconWidget.icon(Icons.message_outlined, size: 38),
  //       title: TextWidget.body1(uid, color: AppColors.onPrimaryContainer),
  //       subtitle: TextWidget.body1(
  //         subtitle,
  //         color: AppColors.onPrimaryContainer,
  //       ),
  //       trailing: IconWidget.icon(Icons.reply_all_outlined, size: 38),
  //     ),
  //     background: AppColors.primaryContainer,
  //   );
  // } else {
  //   NoticeService.to.show(
  //     title: uid,
  //     body: subtitle,
  //     payload: "/chat?uid=$uid&type=$type",
  //   );
  // }
}

/// 开始聊天
Future<void> onChat(String uid, int type) async {
  // 清理堆栈
  Get.until(ModalRoute.withName(RouteNames.main));

  // 跳转到聊天界面
  await Get.toNamed(RouteNames.systemMessageIndex, arguments: {"uid": uid, "type": type});
}

///////////////////////////////////////////
// 会话列表界面

/// 获取会话列表 ChatIndexController
Future<MsgIndexController?> chatIndexPageFind() async {
  // if (Get.isRegistered<ChatIndexController>()) {
  //   ChatIndexController chatIndexController = Get.find<ChatIndexController>();
  //   return chatIndexController;
  // }
  return null;
}

/// 更新会话变化
Future<void> onReceiveConversationChanged(List<V2TimConversation> data) async {
  // var controller = await chatIndexPageFind();
  // controller?.onReceiveConversationChanged(data);
}

/// 删除会话
Future<void> onReceiveConversationDeleted(List<V2TimConversation> data) async {
  // var controller = await chatIndexPageFind();
  // controller?.onReceiveConversationDeleted(data);
}

/// 删除会话根据 cid
Future<void> onReceiveDeleteConversationByCid(String cid) async {
  // var controller = await chatIndexPageFind();
  // controller?.onDeleteConversationByCid(cid);
}

/////////////////////////////////////////////////////////////////////////
/// chat 聊天界面

/// 获取聊天 ChatController
Future<ChatController?> chatPageFind(String tag) async {
  // if (Get.isRegistered<ChatController>(tag: tag)) {
  //   ChatController chatController = Get.find<ChatController>(tag: tag);
  //   return chatController;
  // }
  return null;
}

/// 聊天界面群组信息更新
Future<void> onRecvChatGroupInfoChanged(String tag) async {
  // var controller = await chatPageFind(tag);
  // await controller?.onRecvChatGroupInfoChanged();
}

/// 聊天界面收到新消息
Future<bool> onRecvNewMessage(String tag, V2TimMessage data) async {
  // var controller = await chatPageFind(tag);
  // if (controller != null) {
  //   controller.onRecvNewMessage(data);
  //   return true;
  // }
  return false;
}

/// 关闭聊天界面
Future<void> chatPageGroupClose(tag) async {
  // ChatController? chatController = await chatPageFind(tag);
  // chatController?.onChatClose();
}
