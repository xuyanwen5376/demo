import 'package:flutter/material.dart';

// 更多文本组件
class TextMaxLinesWidget extends StatefulWidget {
  const TextMaxLinesWidget({super.key, required this.content, this.maxLines});

  final String content;
  final int? maxLines;

  @override
  State<TextMaxLinesWidget> createState() => _TextMaxLinesWidgetState();
}

class _TextMaxLinesWidgetState extends State<TextMaxLinesWidget> {
  // 内容
  late final String _content;
  // 最大行数
  late final int _maxLines;

  // 是否展开
  bool _isExpansion = false;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _maxLines = widget.maxLines ?? 3;
  }

  // 主视图
  Widget _mainView() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 将 [TextSpan] 树绘制到 [Canvas] 中的对象。
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: _content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(
            maxWidth: constraints.maxWidth,
          );

        // 准备返回 widget
        if (_isExpansion == false) {
          List<Widget> ws = [];
          if (textPainter.didExceedMaxLines && _isExpansion == false) {
            ws.add(
              Text(
                _content,
                maxLines: _maxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            );
            ws.add(
              GestureDetector(
                onTap: () {
                  _doExpansion();
                },
                child: const Text(
                  "全文",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else {
            ws.add(
              Text(
                _content,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ws,
          );
        } else {
          return Text(
            _content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          );
        }
      },
    );
  }

  void _doExpansion() {
    setState(() {
      _isExpansion = !_isExpansion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
