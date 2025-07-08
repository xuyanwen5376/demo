/// 服务器状态
enum IMServerStatus {
  none,
  connecting, // 正在连接服务器
  success, // 连机成功
  failed, // 连机失败
}

/// 用户状态
enum IMUserStatus {
  none,
  login, // 登录成功
  failed, // 登录失败
  offline, // 断开连接
  expired, // 登录过期
  kicked, // 被踢下线
}

/// 自定义消息
enum IMCustomMessageType {
  c2cCreate, // 单聊天开始
  groupCreate, // 群聊开始
  groupKicked, // 群聊踢出
}

/// 群消息类型
/// 1:主动入群（memberList 加入群组，非 Work 群有效）
/// 2:被邀请入群（opMember 邀请 memberList 入群，Work 群有效）
/// 3:退出群 (opMember 退出群组)
/// 4:踢出群 (opMember 把 memberList 踢出群组)
/// 5:设置管理员 (opMember 把 memberList 设置为管理员)
/// 6:取消管理员 (opMember 取消 memberList 管理员身份)
/// 7:群资料变更 (opMember 修改群资料： groupName & introduction & notification & faceUrl & owner & custom)
/// 8:群成员资料变更 (opMember 修改群成员资料：muteTime)
enum IMGroupTipsType {
  unknown, // 未知
  enter, // 主动入群
  invited, // 被邀请入群
  leave, // 主动退群
  kicked, // 被踢出群
  setAdmin, // 被设置为管理员
  cancelAdmin, // 被取消管理员
  groupInfoChange, // 群资料变更
  memberInfoChange, // 群成员资料变更
}

/// IM 状态
class IMStatus {
  IMServerStatus? server; // 服务器
  IMUserStatus? user; // 用户
  IMStatus({this.server, this.user});
}

class UserModel {
  String? id;
  String? username;
  String? nickName;
  String? avatar;
  String? cover;

  UserModel({this.id, this.username, this.nickName, this.avatar, this.cover});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'] as String? ?? json['id'] as String?,
      username:
          json['username'] as String? ??
          json['attributes']?['username'] as String?,
      nickName:
          json['nickname'] as String? ??
          json['attributes']?['nick_name'] as String?,
      avatar:
          json['avator'] as String? ??
          json['avatar'] as String? ??
          json['attributes']?['avatar'] as String?,
      cover:
          json['cover'] as String? ?? json['attributes']?['cover'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'nick_name': nickName,
    'avatar': avatar,
    'cover': cover,
  };
}
