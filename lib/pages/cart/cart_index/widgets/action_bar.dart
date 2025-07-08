import 'package:flutter/cupertino.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart'; 
import 'package:get/get.dart';

import '../../../../common/index.dart';

/// 顶部操作栏
class ActionBar extends StatelessWidget {
  final bool isAll;
  final Function(bool?)? onAll;
  final Function()? onRemove;

  const ActionBar({
    super.key,
    this.onAll,
    this.isAll = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 选择框
      CheckboxWidget(
        checked: isAll,
        onChanged: onAll,
        title: LocaleKeys.gCartBtnSelectAll.tr,
      ).expanded(),

      // 删除按钮
      ButtonWidget.icon(
        IconWidget.icon(
          CupertinoIcons.delete,
          size: 20.sp,
        ),
        onTap: onRemove,
      ),
    ].toRow();
  }
}
