import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_text_elem.dart';
import '../index.dart';
import 'ai_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class AiController extends GetxController {
  AiController();

  // 输入框控制器
  final TextEditingController inputController = TextEditingController();

  /// 聊天输入栏 key
  GlobalKey<ChatBarWidgetState> chatBarKey = GlobalKey();

  /// 聊天页面滚动控制器
  final ScrollController scrollController = ScrollController();

  // 推荐问题
  final List<String> recommendQuestions = const [
    '今天的老板们还有没有了解AI的呀？',
    '2025年公司真的很难吗？有好的建议吗？',
    '逆境成长，强势崛起，看泡泡玛特的市值',
  ];

  // 聊天列表
  final List<V2TimMessage> messageList = [];

  // 调试开关
  final bool _debugMode = true;

  // 调试日志
  void _debugLog(String message) {
    if (_debugMode) {
      print('[AI调试] $message');
    }
  }

  // 关闭聊天栏
  void onCloseChatBar() {
    chatBarKey.currentState?.onClose();
    update(["ai"]);
  }

  // 发送文字消息
  Future<void> onTextSend(String msg) async {
    final text = msg.trim();
    if (text.isEmpty) return;

    // 创建消息
    V2TimMessage sendMessage = createMessage(text, true);
    // 消息发送中状态
    sendMessage.status = MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC;

    V2TimMessage aiMessage = createMessage('分析中。。。。', false);
    aiMessage.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;

    // // 当前消息加一条记录
    _addMessages([sendMessage, aiMessage]);

    // 更新UI并滚动到底部
    update(['ai']);
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollToBottom();
    });

    // 请求ESS
    requestAIAnswer(msg);
  }

  // 创建消息
  V2TimMessage createMessage(String text, bool isSelf) {
    V2TimMessage message = V2TimMessage(
      elemType: MessageElemType.V2TIM_ELEM_TYPE_TEXT,
      textElem: V2TimTextElem(text: text),
      isSelf: isSelf,
      sender: '消息创建者',
    );
    return message;
  }

  /// 添加消息
  void _addMessages(List<V2TimMessage> data) {
    // 加入消息列表
    for (var index = 0; index < data.length; index++) {
      final current = data[index];
      messageList.add(current);
    }
  }

  // 当前显示的AI回复内容
  String aiDisplayText = '';
  // 是否正在流式打印
  bool isStreaming = false;

  // 刷新ai回复内容
  void refreshAiDisplayText(bool isStreaming) {
    if (messageList.isEmpty) return;

    try {
      // 获取最后一条消息
      final lastMessage = messageList.last;

      if (isStreaming) {
        // 正在流式接收中，更新文本内容
        if (lastMessage.textElem != null) {
          lastMessage.textElem!.text = aiDisplayText;
          _debugLog(
            '更新消息文本: ${aiDisplayText.length > 50 ? aiDisplayText.substring(0, 50) + "..." : aiDisplayText}',
          );
        }
      } else {
        // 接收完成，更新状态
        lastMessage.status = MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC;
        _debugLog('消息接收完成');
      }

      // 更新UI
      update(['ai']);

      // 延迟滚动到底部，确保UI更新完成
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          if (scrollController.hasClients) {
            scrollToBottom();
          }
        } catch (e) {
          print('滚动到底部出错: $e');
        }
      });
    } catch (e) {
      print('刷新AI回复内容出错: $e');
    }
  }

  // 刷新的时候保持页面滚动在最底部
  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 发送消息并流式打印AI回复
  void requestAIAnswer(String query) {
    aiDisplayText = '';
    isStreaming = true;
    update(["ai"]);
    AiService()
        .streamAnswer(
          query: query,
          userId: "bc0606fb6f9141718a18e67ae2353519",
          userName: "谭维敏",
          inputs: {"user_model": "deepseek", "user_network": "NotNetWork"},
        )
        .listen(
          (data) {
            print('AI接口返回: $data'); // 打印每条流式返回

            // 预处理数据
            String processedData = data.trim();
            if (processedData.startsWith('data:')) {
              processedData = processedData.substring(5).trim();
              _debugLog('去除data:前缀后: $processedData');
            }

            try {
              // 尝试解析 JSON
              final map = jsonDecode(processedData);
              _debugLog('成功解析JSON: ${map['event']}');

              // 确保消息开始事件被处理
              _ensureMessageStartHandled(map);

              // 处理消息开始事件
              if (map['event'] == 'message_start') {
                _debugLog('收到消息开始事件');
                if (map.containsKey('answer')) {
                  String answer = map['answer'] ?? '';
                  _debugLog('初始消息内容: $answer');
                  aiDisplayText = answer; // 使用第一条消息作为初始内容
                  refreshAiDisplayText(isStreaming);
                }
              }
              // 处理消息内容
              else if (map['event'] == 'message') {
                // 处理可能的 Markdown 格式
                String answer = map['answer'] ?? '';
                _debugLog('收到消息片段: $answer');

                // 检查消息是否已经显示
                if (!_isMessageAlreadyDisplayed(answer)) {
                  // 如果是代码块的开始，确保格式正确
                  if (answer.contains('```') &&
                      !aiDisplayText.endsWith('\n') &&
                      aiDisplayText.isNotEmpty) {
                    aiDisplayText += '\n';
                    _debugLog('为代码块添加换行');
                  }

                  aiDisplayText += answer;
                  _debugLog('当前完整消息长度: ${aiDisplayText.length}');
                  refreshAiDisplayText(isStreaming);
                }
              }
              // 处理消息结束事件
              else if (map['event'] == 'message_end') {
                _debugLog('收到消息结束事件');
                isStreaming = false;
                refreshAiDisplayText(isStreaming);
              } else {
                _debugLog('收到未知事件类型: ${map['event']}');

                // 尝试提取任何可能的答案
                if (map.containsKey('answer')) {
                  String answer = map['answer'] ?? '';
                  _debugLog('从未知事件中提取答案: $answer');
                  if (!_isMessageAlreadyDisplayed(answer)) {
                    aiDisplayText += answer;
                    refreshAiDisplayText(isStreaming);
                  }
                }
              }
            } catch (e) {
              print('解析数据失败: $e, 原始数据: $data');

              // 尝试使用正则表达式提取 answer 字段
              if (processedData.contains('"answer"')) {
                final RegExp answerRegex = RegExp(r'"answer":"([^"]*)"');
                final match = answerRegex.firstMatch(processedData);
                if (match != null && match.groupCount >= 1) {
                  final String answer = match.group(1) ?? '';
                  _debugLog('通过正则提取answer: $answer');
                  if (!_isMessageAlreadyDisplayed(answer)) {
                    aiDisplayText += answer;
                    refreshAiDisplayText(isStreaming);
                  }
                }
              }
              // 尝试将原始数据作为文本显示
              else if (processedData.isNotEmpty &&
                  !processedData.startsWith('{')) {
                _debugLog('使用原始文本: $processedData');
                aiDisplayText += processedData;
                refreshAiDisplayText(isStreaming);
              }
            }
          },
          onError: (error) {
            print('流数据接收错误: $error');
            isStreaming = false;
            if (messageList.isNotEmpty) {
              final lastMessage = messageList.last;
              lastMessage.textElem?.text = "接收消息出错，请重试";
              lastMessage.status = MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL;
              update(['ai']);
            }
          },
          onDone: () {
            print('流数据接收完成');
            isStreaming = false;
            refreshAiDisplayText(false);
          },
        );
  }

  _initData() {
    update(["ai"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 检查消息是否已经显示
  bool _isMessageAlreadyDisplayed(String answer) {
    // 如果答案为空，不需要显示
    if (answer.isEmpty) return true;

    // 如果当前显示文本为空，肯定没有显示过
    if (aiDisplayText.isEmpty) return false;

    // 检查答案是否已经包含在当前显示文本中
    if (aiDisplayText.contains(answer)) {
      _debugLog('消息已经显示过: $answer');
      return true;
    }

    return false;
  }

  // 确保消息开始事件被正确处理
  void _ensureMessageStartHandled(Map<String, dynamic> map) {
    if (map['event'] == 'message_start') {
      _debugLog('确保消息开始事件被处理');

      // 如果是消息开始事件，并且有 answer 字段
      if (map.containsKey('answer')) {
        String answer = map['answer'] ?? '';
        _debugLog('消息开始事件内容: $answer');

        // 如果当前显示文本为空，或者不包含这个开始消息
        if (aiDisplayText.isEmpty || !aiDisplayText.startsWith(answer)) {
          _debugLog('设置初始消息内容');
          aiDisplayText = answer;
          refreshAiDisplayText(isStreaming);
        }
      }
    }
  }
}
