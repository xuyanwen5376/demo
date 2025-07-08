import 'package:get/get_utils/src/platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';

import 'index.dart';

/// 授权返回
class PrivilegeStatus {
  final bool result;
  final String message;

  PrivilegeStatus({required this.result, required this.message});
}

/// 动态授权
class Privilege {
  /// 是否有相册权限
  static Future<PrivilegeStatus> photos() async {
    var value = false;
    if (GetPlatform.isIOS) {
      var statuses = await [Permission.photos].request();
      value = statuses[Permission.photos] == PermissionStatus.granted;
    }

    // 在 Android 中， Permission.storage 权限与 Android READ_EXTERNAL_STORAGE 和 WRITE_EXTERNAL_STORAGE 权限相关联。
    // 从 Android 10（API 29）开始， READ_EXTERNAL_STORAGE 和 WRITE_EXTERNAL_STORAGE 权限已被标记为已弃用，
    // 并且自 Android 13（API 33）起已完全移除/禁用。
    if (GetPlatform.isAndroid) {
      var permissions = <Permission>[];
      permissions.addAll([Permission.photos]);
      var statuses = await permissions.request();
      value = statuses[Permission.photos] == PermissionStatus.granted;
      // permissions.addAll([Permission.photos, Permission.storage]);
      // var statuses = await permissions.request();
      // value = statuses[Permission.storage] == PermissionStatus.granted &&
      //     statuses[Permission.photos] == PermissionStatus.granted;
    }
    return PrivilegeStatus(
      result: value,
      message: value ? 'ok' : 'Please open photo gallery access',
    );
  }

  /// 是否有相机权限
  static Future<PrivilegeStatus> camera() async {
    var value = false;
    var permissions = <Permission>[];
    permissions
        .addAll([Permission.photos, Permission.camera, Permission.microphone]);
    var statuses = await permissions.request();
    value = statuses[Permission.photos] == PermissionStatus.granted &&
        statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted;
    return PrivilegeStatus(
      result: value,
      message: value ? 'ok' : 'Please turn on camera and microphone access',
    );
  }

  /// 是否有麦克风权限
  static Future<PrivilegeStatus> microphone() async {
    var value = false;
    var statuses = await [Permission.microphone].request();
    value = statuses[Permission.microphone] == PermissionStatus.granted;
    return PrivilegeStatus(
      result: value,
      message: value ? 'ok' : 'Please turn on microphone access',
    );
  }

  /// 是否有存储权限
  static Future<bool> storage() async {
    bool value = false;
    String text = '';
    if (GetPlatform.isAndroid) {
      value = await Permission.storage.request().isGranted;
      text =
          'Please allow access to storage space, settings will be opened soon';
    }
    if (GetPlatform.isIOS) value = true;
    if (!value) {
      Loading.toast(text);
      await Future.delayed(const Duration(seconds: 2));
      openSettings();
    }
    return value;
  }

  /// 打开系统设置
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
