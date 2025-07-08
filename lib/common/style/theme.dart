import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

/// 主题
class AppTheme {
  /////////////////////////////////////////////////
  /// 自定义颜色
  /////////////////////////////////////////////////

  static const primary = Color(0xFF5F84FF);
  static const secondary = Color(0xFFFF6969);
  static const success = Color(0xFF23A757);
  static const warning = Color(0xFFFF1843);
  static const error = Color(0xFFDA1414);
  static const info = Color(0xFF2E5AAC);

  /////////////////////////////////////////////////
  /// 主题
  /////////////////////////////////////////////////

  /// 亮色主题
  static ThemeData get light {
    ColorScheme scheme = MaterialTheme.lightScheme().copyWith(
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF333333),
      error: error,
      onError: Colors.white,
    );
    return _getTheme(scheme);
  }

  /// 暗色主题
  static ThemeData get dark {
    ColorScheme scheme = MaterialTheme.darkScheme().copyWith(
      primary: primary,
      // onPrimary: Colors.white,
      secondary: secondary,
      // onSecondary: Colors.white,
      // surface: const Color(0xFF252525),
      // onSurface: Colors.white,
      error: error,
      onError: Colors.white,
    );
    return _getTheme(scheme);
  }

  /// 获取主题
  static ThemeData _getTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: scheme,
      fontFamily: "Montserrat", // 字体
      // 导航栏
      appBarTheme: AppBarTheme(
        // backgroundColor: scheme.surface, // 背景色
        backgroundColor: Colors.transparent, // 背景色
        scrolledUnderElevation: 0, // 滚动阴影
        elevation: 0, // 阴影
        centerTitle: true, // 标题居中
        toolbarHeight: 56.w, // 高度
        iconTheme: IconThemeData(
          color: scheme.onSurface, // 图标颜色
          size: 22.w, // 图标大小
        ),
        titleTextStyle: TextStyle(
          color: scheme.onSurface, // 字体颜色
          fontSize: 24.w, // 字体大小
          fontWeight: FontWeight.w600, // 字体粗细
          height: 1.2, // 行高
        ),
        toolbarTextStyle: TextStyle(
          color: scheme.onSurface, // 字体颜色
          fontSize: 22.w, // 字体大小
          fontWeight: FontWeight.w600, // 字体粗细
          height: 1.2, // 行高
        ),
      ),
    );
  }
}
