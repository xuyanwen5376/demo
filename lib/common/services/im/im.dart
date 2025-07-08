import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import '../../../pages/index.dart';
import '../../index.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_download_progress.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';

import 'utils.dart';

/// IM 聊天应用服务
class IMService extends GetxService {
  /// 单例对象
  static IMService get to => Get.find();

  // /// IM 状态
  // final PropertyValueNotifier<IMStatus> status =
  //     PropertyValueNotifier<IMStatus>(IMStatus());

  /// 服务器状态
  var serverStatus = IMServerStatus.none.obs;

  /// 用户状态
  var userStatus = IMUserStatus.none.obs;

  /// 是否同步
  final ValueNotifier<bool> isSyncing = ValueNotifier(true);

  /// tim sdk 管理器
  final IMManager manager = IMManager();

  /// 未读消息总数
  final totalUnreadCount = 0.obs;

  /// 初始化
  Future<IMService> init() async {
    try {
      await manager.init(
        // SDK监听器
        sdkListener: V2TimSDKListener(
          // 正在连接的回调函数
          onConnecting: _onConnecting,

          // 连接成功的回调函数
          onConnectSuccess: _onConnectSuccess,

          // 连接失败的回调函数
          // code 错误码
          // error 错误信息
          onConnectFailed: _onConnectFailed,

          // 当前用户被踢下线
          // 此时可以 UI 提示用户
          // 并再次调用 V2TIMManager 的 login() 函数重新登录。
          onKickedOffline: _onKickedOffline,

          // 登录用户的资料发生了更新
          // info登录用户的资料
          onSelfInfoUpdated: _onSelfInfoUpdated,

          // 用户状态改变的回调函数
          // userStatusList 用户状态变化的用户列表
          // 收到通知的情况：订阅过的用户发生了状态变更（包括在线状态和自定义状态），会触发该回调
          // 在 IM 控制台打开了好友状态通知开关，即使未主动订阅，当好友状态发生变更时，也会触发该回调
          // 同一个账号多设备登录，当其中一台设备修改了自定义状态，所有设备都会收到该回调
          onUserStatusChanged: _onUserStatusChanged,

          // 在线时票据过期
          // 此时您需要生成新的 userSig
          // 并再次调用 V2TIMManager 的 login() 函数重新登录。
          onUserSigExpired: _onUserSigExpired,

          onLog: _onLog,
        ),

        // 消息监听
        messageListener: V2TimAdvancedMsgListener(
          onRecvNewMessage: _onRecvNewMessage,
          onRecvMessageModified: _onRecvMessageModified,
          onSendMessageProgress: _onSendMessageProgress,
          onRecvC2CReadReceipt: _onRecvC2CReadReceipt,
          onRecvMessageRevoked: _onRecvMessageRevoked,
          onRecvMessageReadReceipts: _onRecvMessageReadReceipts,
          onRecvMessageExtensionsChanged: _onRecvMessageExtensionsChanged,
          onRecvMessageExtensionsDeleted: _onRecvMessageExtensionsDeleted,
          onMessageDownloadProgressCallback: _onMessageDownloadProgressCallback,
        ),

        // 群监听
        groupListener: V2TimGroupListener(
          onMemberInvited: _onMemberInvited,
          onMemberKicked: _onMemberKicked,
          onMemberLeave: _onMemberLeave,
          onQuitFromGroup: _onQuitFromGroup,
          onGroupInfoChanged: _onGroupInfoChanged,
          onMemberEnter: _onMemberEnter,
          onMemberInfoChanged: _onMemberInfoChanged,
          onGroupDismissed: _onGroupDismissed,
          onGroupRecycled: _onGroupRecycled,
          onReceiveRESTCustomData: _onReceiveRESTCustomData,
        ),

        // 会话监听
        conversationListener: V2TimConversationListener(
          // 同步服务器会话开始
          onSyncServerStart: () {
            isSyncing.value = true;
          },
          // 同步服务器会话失败
          onSyncServerFailed: () {
            isSyncing.value = false;
          },
          // 同步服务器会话完成
          onSyncServerFinish: () {
            isSyncing.value = false;
          },
          onConversationChanged: _onConversationChanged,
          onNewConversation: _onNewConversation,
          // 未读消息数
          onTotalUnreadMessageCountChanged: (count) {
            totalUnreadCount.value = count;
          },
          onConversationGroupCreated: _onConversationGroupCreated,
          onConversationGroupDeleted: _onConversationGroupDeleted,
          onConversationGroupNameChanged: _onConversationGroupNameChanged,
          onConversationsAddedToGroup: _onConversationsAddedToGroup,
          onConversationsDeletedFromGroup: _onConversationsDeletedFromGroup,
        ),
      );
    } catch (error) {
      log(error);
    }

    // 监听服务器状态
    ever<IMServerStatus>(serverStatus, (IMServerStatus newValue) {
      if (newValue == IMServerStatus.failed) {
        OverlayTipUtil.to.showOverlayTip(LocaleKeys.chatErrorConnectFailed.tr);
      } else {
        OverlayTipUtil.to.hideOverlay();
      }
    });

    return this;
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onClose() {
    manager.close();
    super.onClose();
  }

  //////////////////////////////////////////////////////////////////////////
  /// SDK 、用户状态、日志 监听函数

  /// 服务器连接中
  void _onConnecting() {
    log("onConnecting");
    serverStatus.value = IMServerStatus.connecting;
  }

  /// 服务器连接成功
  void _onConnectSuccess() {
    log("onConnectSuccess");
    serverStatus.value = IMServerStatus.success;
  }

  /// 服务器连接失败
  void _onConnectFailed(int code, String msg) {
    log("onConnectFailed");
    serverStatus.value = IMServerStatus.failed;
  }

  /// 当前用户被踢下线
  void _onKickedOffline() {
    log("onKickedOffline");
    userStatus.value = IMUserStatus.kicked;

    // 提示用户重新登陆
    Get.dialog(
      AlertDialog(
        title: Text(LocaleKeys.commonSelectTips.tr),
        content: Text(LocaleKeys.chatErrorKickedOffline.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              login();
            },
            child: Text(LocaleKeys.commonBottomConfirm.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(LocaleKeys.commonBottomCancel.tr),
          ),
        ],
      ),
    );
  }

  /// 登录用户的资料发生了更新
  void _onSelfInfoUpdated(V2TimUserFullInfo info) {
    log("onSelfInfoUpdated");
  }

  /// 用户状态改变的回调函数
  void _onUserStatusChanged(List<V2TimUserStatus> userStatusList) {
    log("onUserStatusChanged");
  }

  /// 在线时票据过期
  void _onUserSigExpired() {
    log("onUserSigExpired");
    userStatus.value = IMUserStatus.expired;

    // 更新令牌
    UserService.to.getProfile();
    // 重新登录
    login();
  }

  /// 日志回调
  void _onLog(int logLevel, String logContent) {
    log({logLevel, logContent});
  }

  //////////////////////////////////////////////////////////////////////////
  /// 用户

  /// 登录
  Future<void> login() async {
    log('login');
    // if (UserService.to.isLogin == false) {
    //   return;
    // }

    // // 检查 profile 和必要字段是否存在
    // final profile = UserService.to.profile;
    // log(
    //   'IM login check - username: ${profile.username}, imSign: ${profile.imSign}',
    // );
    // if (profile == null || profile.username == null || profile.imSign == null) {
    //   log('IM login failed: profile or required fields are null');
    //   userStatus.value = IMUserStatus.failed;
    //   return;
    // }

    // bool isLogin = await manager.login(
    //   userID:  'administrator', //profile.username!,
    //   userSig:  'eJwtjF0LgjAYRv-Lbg2bc-MLug6hLywLwZuXtuLFNJ0jpei-Z*rlc87D*ZDT5mi-lCYRYTYli3GjVJXBG44YZIkVtkaDeer50MoC6holiRyPUhryIKCTUX2NWg1cCMEGNVGD5Z-5wgk587g-V-A*9Hs3Ti3axdfD*VEmcLGyhrP9O83yZbLduV5RddDBujGQ8RX5-gCH0jUy' //profile.imSign!,
    // );

    bool isLogin = await manager.login(
      userID: 'xuyanwen001', //profile.username!,
      userSig:
          'eJwtzEELgjAYxvHvsnPIO9l0Ch3EjA4JiUp0NDbXiziGmSnRd8-U4-P7w-MhxTl3BtWRkLgOkN2yUSrTY40Lj6*pMm9lAOiWn7KprEVJQuoBQMCEgLWo0WKnZuecu3Natcf2bz6nAWOU0e0F9fxeiqlouHd5lEVb3-xkSLVRUmepvtv42EUHm1zzSCTZCfbk*wOGwjNQ',
    );

    userStatus.value = isLogin ? IMUserStatus.login : IMUserStatus.failed;
    totalUnreadCount.value = isLogin ? await manager.getUnreadCount() : 0;
  }

  /// 登出
  Future<void> logout() async {
    await manager.logout();
    totalUnreadCount.value = 0;
  }

  //////////////////////////////////////////////////////////////////////////
  /// 消息

  /// 新消息
  /// [data] 消息
  Future<void> _onRecvNewMessage(V2TimMessage data) async {
    log('_onRecvNewMessage');

    /// 是否打开程序
    final isResumed = true;
    // ConfigService.to.appLifecycle == AppLifecycleState.resumed;

    /// 消息发送者
    String? tag = data.groupID ?? data.sender;

    ChatController? chatController = await chatPageFind(tag!);
    if (chatController != null) {
      chatController.onRecvNewMessage(data);
    }

    return;

    /// 程序打开时 APP 内部消息
    /// 否则系统本地消息
    if (isResumed) {
      bool isRecv = await onRecvNewMessage(tag!, data);
      if (isRecv == false) {
        showAppNotice(data);
      }
    } else {
      showAppNotice(data, isInApp: false);
    }
  }

  /// 消息被修改
  /// [data] 消息
  Future<void> _onRecvMessageModified(V2TimMessage data) async {
    log('_onRecvMessageModified');

    String? tag = data.groupID ?? data.sender;
    ChatController? chatController = await chatPageFind(tag!);
    if (chatController != null) {
      // chatController.onRecvModifyMessage(data);
    }
  }

  /// 消息发送进度
  /// [data] 消息
  /// [progress] 进度 0-100
  void _onSendMessageProgress(V2TimMessage data, int progress) {
    log('_onSendMessageProgress');
  }

  /// 消息被对方已读
  /// [data] 消息
  void _onRecvC2CReadReceipt(List<V2TimMessageReceipt> data) {
    log('_onRecvC2CReadReceipt');
  }

  /// 消息被撤回
  /// [msgID] 消息ID
  void _onRecvMessageRevoked(String msgID) {
    log('_onRecvMessageRevoked');
  }

  /// 消息已读回执
  /// [data] 消息
  void _onRecvMessageReadReceipts(List<V2TimMessageReceipt> data) {
    log('_onRecvMessageReadReceipts');
  }

  /// 消息扩展字段变更
  /// [msgID] 消息ID
  /// [extensions] 扩展字段
  void _onRecvMessageExtensionsChanged(
    String msgID,
    List<V2TimMessageExtension> extensions,
  ) {
    log('_onRecvMessageExtensionsChanged');
  }

  /// 消息扩展字段删除
  /// [msgID] 消息ID
  /// [extensionIDs] 扩展字段ID
  void _onRecvMessageExtensionsDeleted(
    String msgID,
    List<String> extensionIDs,
  ) {
    log('_onRecvMessageExtensionsDeleted');
  }

  /// 消息下载进度
  /// [messageDownloadProgress] 进度回调
  void _onMessageDownloadProgressCallback(
    V2TimMessageDownloadProgress messageDownloadProgress,
  ) {
    log('_onMessageDownloadProgressCallback');
  }

  /// 发出消息
  /// [id] 消息id
  /// [receiver] 接收者id
  /// [type] 会话类型
  Future<V2TimMessage> sendMessage({
    required String id,
    required String receiver,
    int? type,
  }) async {
    final isGroup = type == ConversationType.V2TIM_GROUP;
    V2TimMessage result = await IMService.to.manager.sendMessage(
      id: id,
      uid: !isGroup ? receiver : null,
      gid: isGroup ? receiver : null,
    );
    return result;
  }

  //////////////////////////////////////////////////////////////////////////
  /// 群聊

  /// 进入群
  /// [member] 进入的群成员
  void _onMemberEnter(String gid, List<V2TimGroupMemberInfo> members) {
    log('_onMemberEnter');
    onRecvChatGroupInfoChanged(gid);
    showTip(
      getIMGroupTipsTypeString(
        IMGroupTipsType.enter,
        members: members.map((e) => e.nickName ?? "").toList().join(","),
      ),
    );
  }

  /// 群消息修改
  /// [gid] 群ID
  /// [member] 修改的群成员
  void _onMemberInfoChanged(
    String gid,
    List<V2TimGroupMemberChangeInfo> members,
  ) {
    log('_onMemberInfoChanged');
    onRecvChatGroupInfoChanged(gid);
    showTip(
      getIMGroupTipsTypeString(
        IMGroupTipsType.memberInfoChange,
        members: members.map((e) => e.userID ?? "").toList().join(","),
      ),
    );
  }

  /// 要求入群
  /// [gid] 群ID
  /// [op] 操作者
  /// [member] 申请入群的群成员
  void _onMemberInvited(
    String gid,
    V2TimGroupMemberInfo op,
    List<V2TimGroupMemberInfo> members,
  ) {
    log('_onMemberInvited');
    onRecvChatGroupInfoChanged(gid);
    showTip(
      getIMGroupTipsTypeString(
        IMGroupTipsType.invited,
        members: members.map((e) => e.nickName ?? "").toList().join(","),
      ),
    );
  }

  /// 被踢出群
  /// [gid] 群ID
  /// [op] 操作者
  /// [member] 被踢出群的群成员
  void _onMemberKicked(
    String gid,
    V2TimGroupMemberInfo op,
    List<V2TimGroupMemberInfo> members,
  ) {
    log('_onMemberKicked');

    onRecvChatGroupInfoChanged(gid);
    showTip(
      getIMGroupTipsTypeString(
        IMGroupTipsType.kicked,
        members: members.map((e) => e.nickName ?? "").toList().join(","),
      ),
    );
  }

  /// 成员退出群
  /// [gid] 群ID
  /// [member] 退出的群成员
  void _onMemberLeave(String gid, V2TimGroupMemberInfo member) {
    log('_onMemberLeave');
    onRecvChatGroupInfoChanged(gid);
    showTip(
      getIMGroupTipsTypeString(IMGroupTipsType.leave, members: member.nickName),
    );
  }

  /// 您主动离开群聊
  /// [gid] 群ID
  void _onQuitFromGroup(String gid) {
    log('_onQuitFromGroup');
    onReceiveDeleteConversationByCid("group_$gid");
    showTip(getIMGroupTipsTypeString(IMGroupTipsType.leave));
  }

  /// 群信息修改
  /// [gid] 群ID
  /// [infos] 修改的群信息
  void _onGroupInfoChanged(String gid, List<V2TimGroupChangeInfo> infos) {
    log('_onGroupInfoChanged');
    onRecvChatGroupInfoChanged(gid);
    showTip(getIMGroupTipsTypeString(IMGroupTipsType.groupInfoChange));
  }

  /// 群被解散
  /// [gid] 群ID
  /// [op] 操作者
  Future<void> _onGroupDismissed(String gid, V2TimGroupMemberInfo op) async {
    log('_onGroupDismissed');

    // 读取群名称
    V2TimGroupInfo? groupInfo = await manager.getGroup(gid);
    String groupName = groupInfo?.groupName ?? "";

    // 提示
    Loading.toast("$groupName ${LocaleKeys.chatErrorDismissedGroup.tr}");
    await onReceiveDeleteConversationByCid("group_$gid");
    await chatPageGroupClose(gid);
  }

  /// 群生命周期
  /// [groupID] 群ID
  /// [opUser] 操作者
  Future<void> _onGroupRecycled(
    String groupID,
    V2TimGroupMemberInfo opUser,
  ) async {
    log('_onGroupRecycled');
  }

  /// 群收到服务器推送自定义消息
  /// [gid] 群ID
  /// [customData] 自定义消息
  void _onReceiveRESTCustomData(String gid, String customData) {
    log('_onReceiveRESTCustomData');
  }

  /// 群本地消息
  String groupLocalMessageText(String customType, {String? members}) {
    IMCustomMessageType type = IMCustomMessageType.values.firstWhere(
      (element) => element.toString() == customType,
    );

    switch (type) {
      case IMCustomMessageType.groupCreate:
        return LocaleKeys.chatCustomMessageGroupCreate.trParams({
          "members": members ?? "",
        });
      default:
    }

    return "";
  }

  //////////////////////////////////////////////////////////////////////////
  /// 会话

  /// 有会话新增
  /// [data] 会话列表
  void _onNewConversation(List<V2TimConversation> data) {
    log('_onNewConversation');
    onReceiveConversationChanged(data);
  }

  /// 有会话更新
  /// [data] 会话列表
  void _onConversationChanged(List<V2TimConversation> data) {
    log('_onConversationChanged');
    onReceiveConversationChanged(data);
  }

  /// 会话分组被创建
  /// [groupName] 会话分组名
  /// [data] 会话列表
  void _onConversationGroupCreated(
    String groupName,
    List<V2TimConversation> data,
  ) {
    log('_onConversationGroupCreated');
    onReceiveConversationChanged(data);
  }

  /// 会话分组被删除
  /// [groupName] 会话分组名
  void _onConversationGroupDeleted(String groupName) {
    log('_onConversationGroupDeleted');
    // 会话分组被删除
    // groupName 删除的会话分组名
  }

  /// 会话分组名变更
  /// [oldName] 被修改的会话分组名
  /// [newName] 新的会话分组名
  void _onConversationGroupNameChanged(String oldName, String newName) {
    log('_onConversationGroupNameChanged');
    //会话分组名变更
    //oldName 被修改的会话分组名
    //newName 新的会话分组名
  }

  /// 会话分组新增会话
  /// [groupName] 会话分组名
  /// [data] 会话列表
  void _onConversationsAddedToGroup(
    String groupName,
    List<V2TimConversation> data,
  ) {
    log('_onConversationsAddedToGroup');
    //会话分组新增会话
    //groupName 被新增的会话的分组名
    //conversationList 新增的会话列表
    onReceiveConversationChanged(data);
  }

  /// 会话分组删除会话
  /// [groupName] 会话分组名
  /// [data] 会话列表
  void _onConversationsDeletedFromGroup(
    String groupName,
    List<V2TimConversation> data,
  ) {
    log('_onConversationsDeletedFromGroup');
    //会话分组删除会话
    //groupName 被删除的会话的分组名
    //conversationList 删除的会话列表
    onReceiveConversationDeleted(data);
  }
}
