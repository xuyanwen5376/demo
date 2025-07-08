
import 'package:flutter/foundation.dart';


void log(dynamic object) {
  if (kDebugMode) {
    if (object is Iterable) {
      for (var item in object) {
        print(item);
      }
    } else {
      print(object);
    }
  }
}

// 格式化时间，当天显示 时:分，昨天显示 昨天 时:分，其他显示 月-日 时:分
// String formatTime(int time) {
//   var now = DateTime.now();
//   var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
//   var diff = now.difference(date);
//   if (diff.inDays == 0) {
//     return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
//   } else if (diff.inDays == 1) {
//     return "${LocaleKeys.timeYesterday.tr} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
//   } else {
//     return "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
//   }
// }
