import 'package:flutter/material.dart';

/// 工具函数
class DuTools {
  /// 被系统 UI 部分遮挡的显示部分， 通常通过硬件显示“槽口”或系统状态栏。
  static double bottomBarHeight(context) =>
      MediaQuery.of(context).padding.bottom;

  /// 图片地址格式化
  static String imageUrlFormat(src, {int? width}) {
    // 阿里 oss
    if (src.indexOf("aliyuncs.com") > -1) {
      return src + "?x-oss-process=image/resize,w_${width ?? 150},m_lfit";
    }
    return src;
  }

  /// 根据字符串, 日期格式化
  static String dateTimeFormat(String? dateStr) {
    if (dateStr == null) return "";
    DateTime date = DateTime.parse(dateStr);
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);
    if (diff.inDays > 0) {
      return "${diff.inDays} 天前";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} 小时前";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} 分钟前";
    } else {
      return "刚刚";
    }
  }
}
