import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';

import '../../../common/index.dart';

class ChatFindUserController extends GetxController {
  ChatFindUserController();

  // 刷新控制器
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // 搜索控制器
  final TextEditingController searchEditController = TextEditingController();

  // 页码
  int _page = 1;
  // 页尺寸
  final int _limit = 20;

  // 搜索关键词
  final searchKeyWord = "".obs;

  // 搜索关键词
  String keyword = "";

  // 用户列表
  List<UserModel> items = [];

  // 已选定用户列表
  List<UserModel> selectedUsers = [];

  // 是否选中
  bool isSelected(UserModel user) {
    return selectedUsers.contains(user);
  }

  // 是否有用户选中
  bool hasSelectedUser() {
    return selectedUsers.isNotEmpty;
  }

  // 选择用户
  void onSelectUser(UserModel user) {
    // 已经选中
    if (isSelected(user)) {
      // 移除
      selectedUsers.remove(user);
    } else {
      // 添加
      selectedUsers.add(user);
    }
    update(["chat_find_user"]);
  }

  // 取消选择用户
  void onCancelSelectUser(UserModel user) {
    // 移除
    selectedUsers.remove(user);
    update(["chat_find_user"]);
  }

  // 开始聊天
  Future<void> onStartChat() async {
    if (selectedUsers.isEmpty) {
      return;
    }
    // Get.back(result: selectedUsers);

    await _startChat(selectedUsers);
  } // 选着用户界面

  Future<void> onFindUser() async {
    var result = await Get.toNamed(RouteNames.chatChatFindUser);
    if (result == null || result.isEmpty) return;
    List<UserModel> selectedUsers = result as List<UserModel>;
    log(selectedUsers);
    await _startChat(selectedUsers);
  }

  // 开始聊天
  Future<void> _startChat(List<UserModel> selectedUsers) async {
    if (selectedUsers.isEmpty) {
      return;
    }

    try {
      // 单聊
      if (selectedUsers.length == 1) {
        // 用户 uid
        String uid = 'administrator'; /// selectedUsers.first.username!;

        // tim 数据准备
        // List<String> uids =
        //     selectedUsers
        //         .map((e) => null == e.username ? "" : e.username!)
        //         .toList();
        // await UserApi.chatPrepare(uids);

        // 前去聊天
        Get.toNamed(
          RouteNames.chatChat,
          arguments: {
            "uid": uid,
            "type": ConversationType.V2TIM_C2C.toString(),
          },
        );
      }
    } catch (e) {
      Loading.error(LocaleKeys.chatTipCreateChatFail.tr);
    }

    update(['chat_index']);
  }

  // 初始化数据
  _initData() {
    update(["chat_find_user"]);
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
    _searchDebounce();
    // 手动触发一次刷新
    refreshController.requestRefresh();
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
    searchEditController.dispose();
  }

  // 搜索栏位 - 防抖
  void _searchDebounce() {
    // getx 内置防抖处理
    debounce<String>(
      // obs 对象
      searchKeyWord,

      // 回调函数
      (value) async {
        // 调试
        log("debounce -> $value");
        keyword = value; // 赋值给 controller 的 keyword 字段
        refreshController.requestRefresh(); // 触发下拉刷新
        update(["chat_find_user"]);
      },

      // 延迟 500 毫秒
      time: const Duration(milliseconds: 500),
    );

    // 监听搜索框变化
    searchEditController.addListener(() {
      searchKeyWord.value = searchEditController.text;
    });
  }

  // 上拉载入新数据
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空
        var isEmpty = await _loadSearch(searchKeyWord.value, false);

        if (isEmpty) {
          // 设置无数据
          refreshController.loadNoData();
        } else {
          // 加载完成
          refreshController.loadComplete();
        }
      } catch (e) {
        // 加载失败
        refreshController.loadFailed();
      }
    } else {
      // 设置无数据
      refreshController.loadNoData();
    }
    update(["chat_find_user"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadSearch(searchKeyWord.value, true);
      refreshController.refreshCompleted();
      refreshController.resetNoData();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
    update(["chat_find_user"]);
  }

  // 拉取数据
  // isRefresh 是否是刷新
  Future<bool> _loadSearch(String keyword, bool isRefresh) async {
    // 拉取数据
    var result = await UserApi.findList(
      keyword,
      // 刷新, 重置页数1
      page: isRefresh ? 1 : _page,
      // 每页条数
      pageSize: _limit,
    );

    // 下拉刷新
    if (isRefresh) {
      _page = 1; // 重置页数1
      items.clear(); // 清空数据
    }

    // 有数据
    if (result.isNotEmpty) {
      // 页数+1
      _page++;

      // 添加数据
      items.addAll(result);
    }

    // 是否空
    return result.isEmpty;
  }
}
