import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/bubble.dart';

/// Markdown 聊天气泡组件
class MarkdownBubbleWidget extends StatelessWidget {
  final bool isSender;
  final String text;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final MarkdownStyleSheet? markdownStyleSheet;

  const MarkdownBubbleWidget({
    Key? key,
    this.isSender = true,
    required this.text,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(color: Colors.black87, fontSize: 16),
    this.markdownStyleSheet,
  }) : super(key: key);

  /// 预处理Markdown文本，特别是标题格式
  String _preprocessMarkdown(String text) {
    String processed = text;

    // 1. 修正标题格式 ###1**
    processed = processed.replaceAllMapped(
      RegExp(r'^(#{1,6})(\*{1,2})(.*)$', multiLine: true),
      (match) {
        final hashes = match.group(1) ?? '';
        final stars = match.group(2) ?? '';
        final content = match.group(3) ?? '';
        // 处理标题中的星号，确保正确渲染为加粗效果
        if (stars == '*') {
          return '$hashes *$content*'; // 斜体
        } else if (stars == '**') {
          return '$hashes **$content**'; // 粗体
        } else {
          return '$hashes $content';
        }
      },
    );

    // 2. 确保标题后有空格
    processed = processed.replaceAllMapped(
      RegExp(r'^(#{1,6})([^#\s].*)$', multiLine: true),
      (match) {
        final hashes = match.group(1) ?? '';
        final content = match.group(2) ?? '';
        return '$hashes $content';
      },
    );

    // 3. 确保粗体格式正确 (两边有空格的情况)
    processed = processed.replaceAllMapped(
      RegExp(r'(\s)\*\*([^*]+)\*\*(\s|$)', caseSensitive: false),
      (match) {
        final prefix = match.group(1) ?? '';
        final content = match.group(2) ?? '';
        final suffix = match.group(3) ?? '';
        return '$prefix**$content**$suffix';
      },
    );

    // 4. 确保斜体格式正确
    processed = processed.replaceAllMapped(
      RegExp(r'(\s)\*([^*]+)\*(\s|$)', caseSensitive: false),
      (match) {
        final prefix = match.group(1) ?? '';
        final content = match.group(2) ?? '';
        final suffix = match.group(3) ?? '';
        return '$prefix*$content*$suffix';
      },
    );

    // 5. 处理引用块 (>)
    processed = processed.replaceAllMapped(
      RegExp(r'^\s*>([^\s].*)$', multiLine: true),
      (match) {
        final content = match.group(1) ?? '';
        return '> $content';
      },
    );

    // 6. 处理代码块格式
    processed = processed.replaceAllMapped(
      RegExp(r'```(.*)```', dotAll: true),
      (match) {
        final content = match.group(1) ?? '';
        if (!content.startsWith('\n')) {
          return '```\n$content\n```';
        }
        return match.group(0) ?? '';
      },
    );

    // 7. 处理"思考"标签
    final thinkingPatterns = [
      RegExp(r'<思考>([\s\S]*?)<\/思考>', multiLine: true),
      RegExp(r'【思考】([\s\S]*?)【\/思考】', multiLine: true),
      RegExp(r'「思考」([\s\S]*?)「\/思考」', multiLine: true),
    ];

    for (final pattern in thinkingPatterns) {
      processed = processed.replaceAllMapped(pattern, (match) {
        final content = match.group(1) ?? '';
        final lines = content.split('\n');
        final quoted = lines.map((line) => '> $line').join('\n');
        return '\n**思考过程：**\n$quoted\n';
      });
    }

    // 8. 处理 💭 符号作为引用
    processed = processed.replaceAllMapped(
      RegExp(r'(^|\n)💭\s*(.+)', multiLine: true),
      (match) {
        final prefix = match.group(1) ?? '';
        final content = match.group(2) ?? '';
        return '$prefix> $content';
      },
    );

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    // 预处理文本
    final processedText = _preprocessMarkdown(text);

    // 状态图标
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(Icons.done, size: 18, color: Color(0xFF97AD8E));
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color.fromARGB(255, 97, 101, 101),
      );
    }

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: SpecialChatBubbleOne(
            color: color,
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            tail: tail,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .9,
            ),
            margin:
                isSender
                    ? stateTick
                        ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                        : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                    : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      stateTick
                          ? const EdgeInsets.only(right: 20)
                          : EdgeInsets.zero,
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: text)).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('已复制到剪贴板'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      });
                    },
                    child: MarkdownBody(
                      data: processedText,
                      styleSheet:
                          markdownStyleSheet ??
                          MarkdownStyleSheet.fromTheme(
                            Theme.of(context),
                          ).copyWith(
                            p: textStyle,
                            a: textStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            code: textStyle.copyWith(
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              fontFamily: 'monospace',
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            blockquoteDecoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 4.0,
                                ),
                              ),
                            ),
                            blockquote: textStyle.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                            strong: textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            em: textStyle.copyWith(fontStyle: FontStyle.italic),
                            h1: textStyle.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: textStyle.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: textStyle.copyWith(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            h4: textStyle.copyWith(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            h5: textStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            h6: textStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          try {
                            final uri = Uri.parse(href);
                            launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            debugPrint('链接打开失败: $e');
                          }
                        }
                      },
                    ),
                  ),
                ),
                if (stateIcon != null && stateTick)
                  Positioned(bottom: 0, right: 0, child: stateIcon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
