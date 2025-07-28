import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../../../common/index.dart';

/// 资讯页面顶部标语组件
class NewsHeaderWidget extends StatelessWidget {
  final String? quote; // 引言内容
  final String? author; // 作者
  final String? position; // 职位

  const NewsHeaderWidget({
    super.key,
    this.quote = "数字化转型的本质是用技术重新定义商业模式，创造新的价值增长点。",
    this.author = "张勇",
    this.position = "阿里巴巴CEO",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // 浅灰色背景
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          // 引言文本部分
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: '"$quote"'),
                  TextSpan(
                    text: ' ——$author ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: position),
                ],
              ),
            ),
          ),

          // 右侧星星图标
          Container(
            margin: EdgeInsets.only(left: 8.w),
            child: Icon(Icons.star, color: Colors.redAccent, size: 24.w),
          ),
        ],
      ),
    );
  }
}
