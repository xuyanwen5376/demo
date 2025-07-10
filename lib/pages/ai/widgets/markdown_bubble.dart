import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../../common/widgets/bubble.dart';

/// Markdown 聊天气泡组件
///
/// 支持 Markdown 格式的消息渲染
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

  /// 检测文本是否包含 Markdown 格式或URL
  bool _containsMarkdown(String text) {
    // 简单检测一些常见的 Markdown 语法
    final markdownPatterns = [
      RegExp(r'\*\*.+?\*\*'), // 粗体
      RegExp(r'\*.+?\*'), // 斜体
      RegExp(r'_.+?_'), // 斜体
      RegExp(r'#{1,6}\s.+'), // 标题
      RegExp(r'```[\s\S]*?```'), // 代码块
      RegExp(r'`[^`]+`'), // 行内代码
      RegExp(r'\[.+?\]\(.+?\)'), // 链接
      RegExp(r'!\[.+?\]\(.+?\)'), // 图片
      RegExp(r'- .+'), // 无序列表
      RegExp(r'\d+\. .+'), // 有序列表
      RegExp(r'> .+'), // 引用
      RegExp(r'\|.+\|.+\|'), // 表格
      // URL正则表达式
      RegExp(r'https?:\/\/[^\s]+'), // 简单URL
      RegExp(r'www\.[^\s]+\.[^\s]+'), // 以www开头的URL
      RegExp(r'[^\s]+\.(com|org|net|gov|io|app|co)[^\s]*'), // 常见顶级域名
      // 新增：思考部分格式
      RegExp(r'<思考>[\s\S]*?<\/思考>'), // 思考标签
      RegExp(r'【思考】[\s\S]*?【\/思考】'), // 中文思考标签
      RegExp(r'「思考」[\s\S]*?「\/思考」'), // 另一种中文思考标签
    ];

    // 总是返回true以确保文本被当作Markdown处理
    return true;
  }

  /// 预处理文本，识别并转换URL为Markdown链接格式
  String _preprocessText(String text) {
    // 先处理编码字符
    String processedText = text;

    try {
      // 1. 首先清理文本，处理可能的空格和特殊字符
      processedText = processedText.trim();

      // 处理思考部分格式
      processedText = _processThinkingBlocks(processedText);

      // 2. 分割文本，识别可能的多个链接
      List<String> possibleLinks = _splitPossibleLinks(processedText);

      // 3. 处理每个可能的链接
      for (var i = 0; i < possibleLinks.length; i++) {
        String part = possibleLinks[i];

        // 如果这部分看起来像链接，处理它
        if (_looksLikeUrl(part)) {
          possibleLinks[i] = _processUrlPart(part);
        }
      }

      // 4. 重新组合文本
      processedText = possibleLinks.join(' ');

      // 5. 处理特殊URL格式
      final urlRegexPatterns = [
        // 标准HTTP/HTTPS URL
        r'(https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*))',
        // 以www开头但没有协议的URL
        r'(www\.[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*))',
        // 常见顶级域名的URL，没有www或协议
        r'((?:[-a-zA-Z0-9@:%._\+~#=]{1,256}\.)+(?:com|org|net|gov|io|app|co|edu|info|biz|oschina|jianshu)(?:\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?)',
      ];

      // 6. 处理URL编码字符
      if (processedText.contains('%')) {
        try {
          final encodedUrlRegex = RegExp(
            r'https?:\/\/[^"\s\]>]+%[^"\s\]>]+',
            caseSensitive: false,
          );

          final encodedMatches = encodedUrlRegex.allMatches(processedText);

          for (var match in encodedMatches.toList().reversed) {
            final encodedUrl = processedText.substring(match.start, match.end);

            try {
              // 尝试解码URL
              final decodedUrl = Uri.decodeFull(encodedUrl);

              // 只有当解码后的URL与原URL不同时才替换
              if (decodedUrl != encodedUrl) {
                processedText = processedText.replaceRange(
                  match.start,
                  match.end,
                  decodedUrl,
                );
              }
            } catch (e) {
              debugPrint('URL解码失败: $e');
            }
          }
        } catch (e) {
          debugPrint('处理编码URL时出错: $e');
        }
      }

      // 7. 处理以@开头的URL
      final atUrlRegex = RegExp(r'@(https?:\/\/[^\s]+)', caseSensitive: false);
      final atMatches = atUrlRegex.allMatches(processedText);

      for (var match in atMatches.toList().reversed) {
        final url = processedText.substring(match.start + 1, match.end); // 去掉@
        processedText = processedText.replaceRange(
          match.start,
          match.end,
          '[$url]($url)',
        );
      }

      // 8. 处理每种URL模式
      for (var pattern in urlRegexPatterns) {
        final urlRegex = RegExp(pattern, caseSensitive: false);
        final matches = urlRegex.allMatches(processedText);

        // 从后向前替换，避免索引变化
        final List<RegExpMatch> reversedMatches =
            matches.toList().reversed.toList();

        for (var match in reversedMatches) {
          final url = processedText.substring(match.start, match.end);

          // 检查这个URL是否已经是Markdown链接的一部分
          bool isInMarkdownLink = false;

          // 查找这个URL前面是否有 '](' 标记
          final beforeUrl = processedText.substring(0, match.start);
          if (beforeUrl.contains('](') &&
              processedText.substring(match.end).contains(')')) {
            final closingBracketIndex = beforeUrl.lastIndexOf('](');
            final openingBracketIndex = beforeUrl.lastIndexOf(
              '[',
              closingBracketIndex,
            );

            if (openingBracketIndex != -1 && closingBracketIndex != -1) {
              isInMarkdownLink = true;
            }
          }

          // 如果不是Markdown链接的一部分，则转换为Markdown链接
          if (!isInMarkdownLink) {
            // 确保URL有协议前缀
            String displayUrl = url;
            String fullUrl = url;

            if (!fullUrl.startsWith('http://') &&
                !fullUrl.startsWith('https://')) {
              fullUrl = 'https://$url';
            }

            processedText = processedText.replaceRange(
              match.start,
              match.end,
              '[$displayUrl]($fullUrl)',
            );
          }
        }
      }

      // 9. 处理特殊的混合链接
      processedText = _handleMixedUrls(processedText);

      // 10. 确保代码块格式正确
      processedText = _ensureCodeBlocksFormatting(processedText);

      // 11. 确保思考部分格式正确
      processedText = _processThinkingBlocks(processedText);
    } catch (e) {
      debugPrint('处理文本时出错: $e');
    }

    return processedText;
  }

  /// 处理思考部分格式
  String _processThinkingBlocks(String text) {
    // 将各种思考标签统一转换为Markdown引用格式
    String processed = text;

    // 处理<思考>标签
    processed = processed.replaceAllMapped(
      RegExp(r'<思考>([\s\S]*?)<\/思考>', multiLine: true),
      (match) {
        // 获取思考内容并按行分割
        String content = match.group(1) ?? '';
        List<String> lines = content.split('\n');

        // 将每一行前面添加引用符号 >
        String quotedContent = lines.map((line) => '> $line').join('\n');

        // 添加一些样式，使其更明显
        return '\n**思考过程：**\n$quotedContent\n';
      },
    );

    // 处理【思考】标签
    processed = processed.replaceAllMapped(
      RegExp(r'【思考】([\s\S]*?)【\/思考】', multiLine: true),
      (match) {
        String content = match.group(1) ?? '';
        List<String> lines = content.split('\n');
        String quotedContent = lines.map((line) => '> $line').join('\n');
        return '\n**思考过程：**\n$quotedContent\n';
      },
    );

    // 处理「思考」标签
    processed = processed.replaceAllMapped(
      RegExp(r'「思考」([\s\S]*?)「\/思考」', multiLine: true),
      (match) {
        String content = match.group(1) ?? '';
        List<String> lines = content.split('\n');
        String quotedContent = lines.map((line) => '> $line').join('\n');
        return '\n**思考过程：**\n$quotedContent\n';
      },
    );

    return processed;
  }

  /// 确保代码块格式正确
  String _ensureCodeBlocksFormatting(String text) {
    String processed = text;

    // 查找所有代码块
    final codeBlocks = RegExp(r'```[^\n]*\n[\s\S]*?```').allMatches(text);

    // 确保代码块前后有换行
    for (var match in codeBlocks.toList().reversed) {
      String block = processed.substring(match.start, match.end);

      // 确保代码块前有换行
      if (match.start > 0 && processed[match.start - 1] != '\n') {
        processed = processed.replaceRange(match.start, match.start, '\n');
      }

      // 确保代码块后有换行
      if (match.end < processed.length && processed[match.end] != '\n') {
        processed = processed.replaceRange(match.end, match.end, '\n');
      }
    }

    return processed;
  }

  /// 分割可能的链接
  List<String> _splitPossibleLinks(String text) {
    // 使用空格分割，但保留URL中的空格
    List<String> result = [];
    bool inUrl = false;
    String currentPart = '';

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      // 检查是否进入或离开URL
      if (char == 'h' &&
          i + 4 < text.length &&
          text.substring(i, i + 4) == 'http') {
        inUrl = true;
      } else if (char == ' ' && !inUrl) {
        if (currentPart.isNotEmpty) {
          result.add(currentPart);
          currentPart = '';
        }
        continue;
      } else if (char == ' ' && _isUrlEnd(text, i)) {
        inUrl = false;
      }

      currentPart += char;

      // 如果到达文本末尾，添加最后一部分
      if (i == text.length - 1 && currentPart.isNotEmpty) {
        result.add(currentPart);
      }
    }

    return result;
  }

  /// 检查URL是否结束
  bool _isUrlEnd(String text, int position) {
    // 检查URL是否在此位置结束
    if (position + 1 >= text.length) return true;

    // 检查后面的字符是否是URL的有效部分
    String nextChar = text[position + 1];
    return !RegExp(r'[a-zA-Z0-9\-_\.\/\?=&%]').hasMatch(nextChar);
  }

  /// 检查文本是否看起来像URL
  bool _looksLikeUrl(String text) {
    // 检查是否包含常见的URL特征
    return text.contains('http://') ||
        text.contains('https://') ||
        text.contains('www.') ||
        RegExp(r'\.[a-z]{2,}\/').hasMatch(text) ||
        RegExp(r'\.(com|org|net|gov|io|app|co)').hasMatch(text);
  }

  /// 处理URL部分
  String _processUrlPart(String part) {
    // 处理可能是URL的部分
    try {
      // 1. 尝试提取有效URL
      List<String> urls = _extractUrls(part);

      // 2. 如果没有找到URL，返回原始部分
      if (urls.isEmpty) return part;

      // 3. 处理每个URL
      for (var url in urls) {
        String cleanUrl = _cleanUrl(url);
        part = part.replaceAll(url, '[$cleanUrl]($cleanUrl)');
      }

      return part;
    } catch (e) {
      debugPrint('处理URL部分时出错: $e');
      return part;
    }
  }

  /// 提取URL
  List<String> _extractUrls(String text) {
    List<String> urls = [];

    // 匹配各种URL格式
    final urlRegexes = [
      RegExp(r'https?:\/\/[^\s]+', caseSensitive: false),
      RegExp(r'www\.[^\s]+\.[^\s]+', caseSensitive: false),
      RegExp(
        r'[^\s]+\.(com|org|net|gov|io|app|co|edu|info|biz|oschina|jianshu)[^\s]*',
        caseSensitive: false,
      ),
    ];

    for (var regex in urlRegexes) {
      final matches = regex.allMatches(text);
      for (var match in matches) {
        urls.add(text.substring(match.start, match.end));
      }
    }

    return urls;
  }

  /// 清理URL
  String _cleanUrl(String url) {
    // 清理URL，移除不必要的字符
    String cleanUrl = url.trim();

    // 移除URL末尾的标点符号
    if (cleanUrl.endsWith('.') ||
        cleanUrl.endsWith(',') ||
        cleanUrl.endsWith(';') ||
        cleanUrl.endsWith(':') ||
        cleanUrl.endsWith(')')) {
      cleanUrl = cleanUrl.substring(0, cleanUrl.length - 1);
    }

    return cleanUrl;
  }

  /// 处理混合URL
  String _handleMixedUrls(String text) {
    // 处理可能混合在一起的多个URL
    String processedText = text;

    // 1. 查找可能的域名部分
    final domainRegex = RegExp(
      r'([a-zA-Z0-9-]+\.(com|org|net|gov|io|app|co|edu|info|biz|oschina|jianshu))',
      caseSensitive: false,
    );
    final domainMatches = domainRegex.allMatches(processedText);

    // 从后向前处理，避免索引变化
    for (var match in domainMatches.toList().reversed) {
      // 获取域名
      final domain = processedText.substring(match.start, match.end);

      // 检查这个域名是否已经是链接的一部分
      if (!_isPartOfMarkdownLink(processedText, match.start, match.end)) {
        // 查找域名前后的文本，判断是否是同一个URL的一部分
        final beforeDomain =
            match.start > 0 ? processedText.substring(0, match.start) : '';
        final afterDomain =
            match.end < processedText.length
                ? processedText.substring(match.end)
                : '';

        // 如果域名前有www.或http://或https://，扩展匹配范围
        int startPos = match.start;
        if (beforeDomain.endsWith('www.')) {
          startPos = beforeDomain.lastIndexOf('www.');
        } else if (beforeDomain.endsWith('http://')) {
          startPos = beforeDomain.lastIndexOf('http://');
        } else if (beforeDomain.endsWith('https://')) {
          startPos = beforeDomain.lastIndexOf('https://');
        }

        // 如果域名后有路径，扩展匹配范围
        int endPos = match.end;
        if (afterDomain.startsWith('/') ||
            afterDomain.startsWith('?') ||
            afterDomain.startsWith('#')) {
          // 查找URL的结束位置
          for (int i = 0; i < afterDomain.length; i++) {
            if (afterDomain[i] == ' ' ||
                afterDomain[i] == '\n' ||
                afterDomain[i] == '\t') {
              endPos = match.end + i;
              break;
            }
            if (i == afterDomain.length - 1) {
              endPos = match.end + afterDomain.length;
            }
          }
        }

        // 提取完整URL
        if (startPos != match.start || endPos != match.end) {
          final fullUrl = processedText.substring(startPos, endPos);
          String cleanUrl = fullUrl;

          // 确保URL有协议前缀
          String linkUrl = cleanUrl;
          if (!linkUrl.startsWith('http://') &&
              !linkUrl.startsWith('https://')) {
            linkUrl = 'https://$cleanUrl';
          }

          // 替换为Markdown链接
          processedText = processedText.replaceRange(
            startPos,
            endPos,
            '[$cleanUrl]($linkUrl)',
          );
        } else {
          // 如果只有域名，直接转换为链接
          processedText = processedText.replaceRange(
            match.start,
            match.end,
            '[$domain](https://$domain)',
          );
        }
      }
    }

    // 2. 特殊处理jianshu.com和oschina.net链接
    final specialDomains = ['jianshu.com', 'oschina.net'];
    for (var domain in specialDomains) {
      if (processedText.contains(domain)) {
        // 查找包含这个域名的文本
        int startIdx = processedText.indexOf(domain);
        if (startIdx > 0) {
          // 向前查找可能的URL开始
          int urlStart = startIdx;
          for (int i = startIdx - 1; i >= 0; i--) {
            if (processedText[i] == ' ' ||
                processedText[i] == '\n' ||
                processedText[i] == '\t') {
              urlStart = i + 1;
              break;
            }
            if (i == 0) {
              urlStart = 0;
            }
          }

          // 向后查找可能的URL结束
          int urlEnd = startIdx + domain.length;
          for (int i = urlEnd; i < processedText.length; i++) {
            if (processedText[i] == ' ' ||
                processedText[i] == '\n' ||
                processedText[i] == '\t') {
              urlEnd = i;
              break;
            }
            if (i == processedText.length - 1) {
              urlEnd = processedText.length;
            }
          }

          // 提取完整URL
          final fullUrl = processedText.substring(urlStart, urlEnd);

          // 检查是否已经是链接
          if (!fullUrl.contains('](') && !fullUrl.startsWith('[')) {
            String cleanUrl = fullUrl;

            // 确保URL有协议前缀
            String linkUrl = cleanUrl;
            if (!linkUrl.startsWith('http://') &&
                !linkUrl.startsWith('https://')) {
              linkUrl = 'https://$cleanUrl';
            }

            // 替换为Markdown链接
            processedText = processedText.replaceRange(
              urlStart,
              urlEnd,
              '[$cleanUrl]($linkUrl)',
            );
          }
        }
      }
    }

    return processedText;
  }

  /// 显示错误提示
  void _showErrorSnackbar(String message) {
    // 使用Future.microtask来避免在构建过程中显示SnackBar
    Future.microtask(() {
      try {
        Get.snackbar(
          '链接错误',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } catch (e) {
        debugPrint('显示错误提示时出错: $e');
      }
    });
  }

  /// 处理链接点击
  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      // 使用Future.microtask避免TextInput断言错误
      Future.microtask(() async {
        try {
          // 清理URL，移除可能的前缀或后缀
          String cleanUrl = url.trim();

          // 处理特殊情况：以@开头的URL
          if (cleanUrl.startsWith('@http')) {
            cleanUrl = cleanUrl.substring(1);
          }

          // 处理特殊情况：包含多个域名部分的URL
          if (cleanUrl.contains('comzh-c')) {
            // 尝试修复格式错误的URL
            cleanUrl = cleanUrl.replaceAll('comzh-c', 'com/zh-c');
          }

          // 确保URL有协议前缀
          if (!cleanUrl.startsWith('http://') &&
              !cleanUrl.startsWith('https://')) {
            cleanUrl = 'https://$cleanUrl';
          }

          debugPrint('尝试打开链接: $cleanUrl');

          // 尝试解析URL
          Uri? uri;
          try {
            uri = Uri.parse(cleanUrl);
          } catch (e) {
            debugPrint('URL解析失败: $e');
            _showErrorSnackbar('链接格式错误，无法解析');
            return;
          }

          // 使用延迟避免TextInput断言错误
          await Future.delayed(const Duration(milliseconds: 300));

          // 尝试打开链接
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint('无法打开链接: $cleanUrl');
            _showErrorSnackbar('无法打开链接: $cleanUrl');
          }
        } catch (e) {
          debugPrint('处理链接时出错: $e');
          _showErrorSnackbar('链接格式错误，无法打开');
        }
      });
    } catch (e) {
      debugPrint('启动链接处理时出错: $e');
      _showErrorSnackbar('无法处理链接请求');
    }
  }

  /// 检查文本范围是否已经是Markdown链接的一部分
  bool _isPartOfMarkdownLink(String text, int start, int end) {
    // 检查这个URL前面是否有 '](' 标记
    final beforeUrl = text.substring(0, start);
    if (beforeUrl.contains('](')) {
      final closingBracketIndex = beforeUrl.lastIndexOf('](');
      final openingBracketIndex = beforeUrl.lastIndexOf(
        '[',
        closingBracketIndex,
      );

      // 检查是否有对应的右括号在URL之后
      if (openingBracketIndex != -1 && closingBracketIndex != -1) {
        final afterUrl = text.substring(end);
        if (afterUrl.contains(')')) {
          return true;
        }
      }
    }

    // 检查这个URL是否在方括号内
    int openBracketCount = 0;
    for (int i = 0; i < start; i++) {
      if (text[i] == '[') openBracketCount++;
      if (text[i] == ']') openBracketCount--;
    }

    // 如果有未闭合的方括号，说明URL在方括号内
    return openBracketCount > 0;
  }

  @override
  Widget build(BuildContext context) {
    // 预处理文本，识别并转换URL为Markdown链接格式
    final processedText =
        _containsMarkdown(text) ? _preprocessText(text) : text;

    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      // 已发送
      stateIcon = const Icon(Icons.done, size: 18, color: Color(0xFF97AD8E));
    }
    // 已送达
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    // 已读
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
                          : const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ),
                  // 使用SafeArea包装MarkdownBody，避免溢出
                  child: SafeArea(
                    child: GestureDetector(
                      // 长按事件处理
                      onLongPress: () {
                        // 复制文本到剪贴板
                        Clipboard.setData(ClipboardData(text: text)).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已复制到剪贴板'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        });
                      },
                      child: Builder(
                        builder: (context) {
                          return MarkdownBody(
                            data: processedText,
                            styleSheet:
                                markdownStyleSheet ??
                                MarkdownStyleSheet.fromTheme(
                                  Theme.of(context),
                                ).copyWith(
                                  p: textStyle,
                                  a: textStyle.copyWith(
                                    // 链接颜色
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  code: textStyle.copyWith(
                                    // 代码块背景颜色
                                    backgroundColor: Colors.grey.withOpacity(
                                      0.2,
                                    ),
                                    fontFamily: 'monospace',
                                  ),
                                  codeblockDecoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            onTapLink: (text, href, title) {
                              _launchUrl(href);
                            },
                            // 禁用文本选择功能，完全避免TextInput断言错误
                            selectable: false,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                stateIcon != null && stateTick
                    ? Positioned(bottom: 0, right: 0, child: stateIcon)
                    : const SizedBox(width: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
