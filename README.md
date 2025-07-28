# Boss Flutter App

这是一个基于Flutter开发的应用程序，提供用户登录、注册、 等功能。


# 演示
https://github.com/xuyanwen5376/demo/blob/main/tinywow_Simulator%20Screen%20Recording%20-%20iPhone%2016%20-%202025-07-28%20at%2015.47.12_82808679.gif


## 功能特性

- 用户认证系统（登录、注册、找回密码） 
- 用户个人中心
- 多语言支持
- 暗黑模式切换

## 技术栈

- Flutter
- GetX 状态管理
- RESTful API 集成
- 腾讯云IM即时通讯
- 自定义UI组件库

## 最近更新功能

### 验证码倒计时功能

在登录页面实现了验证码发送功能，包含以下特性：

1. 点击发送按钮后开始60秒倒计时
2. 倒计时期间按钮显示剩余秒数
3. 倒计时期间按钮被禁用
4. 倒计时结束后按钮文字变为"重新发送"
5. 按钮与输入框垂直居中对齐

### 实现代码

倒计时控制器代码：
```dart
// 倒计时秒数
int countdown = 0;

// 是否已发送过验证码
bool hasSentCode = false;

// 倒计时定时器
Timer? _timer;

/// 发送验证码
void onSendVerificationCode() {
  if (countdown > 0) return; // 倒计时中不允许再次发送
  
  print("发送验证码");
  
  // 标记为已发送过验证码
  hasSentCode = true;
  
  // 开始倒计时 60s
  countdown = 60;
  update(["login"]);
  
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    countdown--;
    update(["login"]);
    if (countdown <= 0) {
      _timer?.cancel();
      _timer = null;
    }
  });
}
```

UI展示代码：
```dart
ButtonWidget.primary(
  // 根据倒计时状态显示不同文本
  controller.countdown > 0 
    ? "${controller.countdown}秒"
    : controller.hasSentCode 
        ? "重新发送" 
        : LocaleKeys.loginVerificationCodeSend.tr,
  onTap: controller.onSendVerificationCode,
  // 倒计时期间禁用按钮
  enabled: controller.countdown <= 0,
).tight(width: 100.w)
```

## 开始使用

1. 确保已安装Flutter开发环境
2. 克隆项目代码
3. 运行 `flutter pub get` 安装依赖
4. 运行 `flutter run` 启动应用

## 开发规范

- 使用GetX进行状态管理
- 页面目录结构: pages/[功能]/[页面]/index.dart, controller.dart, view.dart, binding.dart
- 遵循MVVM架构模式
- 组件化开发，提高代码复用性
