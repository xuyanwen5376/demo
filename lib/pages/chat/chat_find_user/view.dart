import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/index.dart';
import 'index.dart';

class ChatFindUserPage extends GetView<ChatFindUserController> {
  const ChatFindUserPage({super.key});

  // 列表项
  Widget _buildListItem({required UserModel item}) {
    return ListTile(
      leading:
          item.avatar == null
              ? InitialsWidget(item.nickName!)
              : AvatarWidget("${Constants.imageServer}/avatar/${item.avatar}"),
      title: Text(item.nickName ?? ""),
      // subtitle: Text(item.email),
      trailing:
          item.nickName == UserService.to.profile.nickName
              ? const Icon(Icons.person_add_disabled_outlined)
              : controller.isSelected(item)
              ? const Icon(Icons.check_box_outlined)
              : const Icon(Icons.check_box_outline_blank),
      enabled: item.nickName != UserService.to.profile.nickName,
      onTap:
          item.nickName == UserService.to.profile.nickName
              ? null
              : () {
                controller.onSelectUser(item);
              },
    );
  }

  // 已选定列表
  Widget _buildSelectedList() {
    return Wrap(
      spacing: 5,
      runSpacing: 0,
      children:
          controller.selectedUsers
              .map(
                (item) => Chip(
                  avatar:
                      item.avatar == null
                          ? InitialsWidget(item.nickName!)
                          : AvatarWidget(
                            "${Constants.imageServer}/avatar/${item.avatar}",
                            size: const Size(18, 18),
                          ),
                  label: TextWidget.body(item.nickName ?? "").width(20),
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  onDeleted: () {
                    controller.onCancelSelectUser(item);
                  },
                ),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatFindUserController>(
      init: ChatFindUserController(),
      id: "chat_find_user",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: ButtonWidget.icon(
              IconWidget.icon(Icons.arrow_back_ios_new_outlined),
              onTap: () {
                Get.back();
              },
            ),

            // 搜索栏
            title: InputWidget(
              placeholder: "搜索用户",
              controller: controller.searchEditController,
              // cleanable: true,
              // onChanged: (value) {
              //   controller.searchKeyWord.value = value;
              // },
            ).limitedBox(maxHeight: 50),

            // title: InputWidget.textBorder(
            //   controller: controller.searchEditController,
            // ).limitedBox(maxHeight: 30),
            // 开聊按钮
            actions:
                controller.hasSelectedUser()
                    ? [
                      ButtonWidget.primary(
                        LocaleKeys.chatBtnStart.tr,
                        onTap: controller.onStartChat,
                        height: 30,
                        width: 40,
                      ).paddingRight(5),
                    ]
                    : null,
            // 间距
            titleSpacing: 5,
            // 高度
            toolbarHeight: 30,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 已选定用户列表
                if (controller.selectedUsers.isNotEmpty)
                  _buildSelectedList()
                      .paddingHorizontal(AppSpace.page)
                      .paddingVertical(AppSpace.listRow),

                // 用户列表
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController, 
                    onRefresh: controller.onRefresh,
                    onLoading: controller.onLoading, 
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpace.page),
                      itemBuilder: (context, index) {
                        UserModel item = controller.items[index];
                        return _buildListItem(
                          item: item,
                        ).paddingBottom(AppSpace.listRow);
                      },
                      itemCount: controller.items.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
