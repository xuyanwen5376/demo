import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class AiService {
  static const String apiUrl =
      'https://erptest.bosum.com/erp/market/app/ai/conversation/chat';

  /// 真实 API 流式返回
  Stream<String> streamAnswer({
    required String query,
    required String userId,
    required String userName,
    required Map<String, dynamic> inputs,
    String? conversationId,
    int dialogueNumber = 1,
  }) async* {
    print('[AiService] streamAnswer called');
    final data =
    // {
    //   "inputs": inputs,
    //   "query": query,
    //   "userId": userId,
    //   "userName": userName,
    // };
    {
      "appId": "796dd006e324kd97df86f8sg07343",
      "conversationId": "eea98fc6-3fea-4855-a0fb-84953d8e6311",
      "inputs": {"user_model": "deepseek", "user_network": "IsNetWork"},
      "query": query,
      "userId": "bc0606fb6f9141718a18e67ae2353519",
      "userName": "谭维敏",
    };

    // print('[AiService] 请求参数: ' + jsonEncode(data));
    var options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json,
    );
    var dio = Dio(options);
    try {
      final response = await dio.post(
        apiUrl,
        data: jsonEncode(data),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "Accept": "text/event-stream",
            "Authorization":
                "eyJhbGciOiJIUzUxMiJ9.eyJhZ2VuY3lJZCI6IjIiLCJ1c2VySWQiOiJiYzA2MDZmYjZmOTE0MTcxOGExOGU2N2FlMjM1MzUxOSIsInVzZXJDb2RlIjoiQjA0MTQxIiwidXNlck5hbWUiOiLosK3nu7TmlY8iLCJkZXB0SWQiOiJkNGM0MDgyN2FjNjc0MDE3OTRkZTQ1ZmM5ZWEzMTZjNSIsImlzU3VwZXIiOmZhbHNlLCJpc01hbmFnZXIiOnRydWUsInVzZXJfa2V5IjoiODgwZjk0ZTUtMjZkZS00OGY3LThkYjQtNzg4OGYwMDU1NDYzIiwiQ0xJRU5UX1RZUEUiOiJBUFAifQ.5tQLeArHFItYy2CwRXvv8AUDVaQDExgcndDD1-xp39W6qUniWCZSXY-2YE3NiEyuXDN8kgoSqg88y3yGTi7EwA",
            "Cache-Control": "no-cache",
            "Clienttype": "APP",
            "Connection": "keep-alive",
            "Content-Type": "application/json",
            "userPhoneToken":
                "bc0606fb6f9141718a18e67ae2353519@@8ad29a5bd3cb423789584d531bf7d976",
          },
        ),
      );
      print('[AiService] 请求已发出，开始处理流...');
      final stream = response.data.stream.cast<List<int>>().transform(
        utf8.decoder,
      );
      await for (final chunk in stream) {
        print('-----------------------');
        print('[AiService] 收到chunk: $chunk');
        print('-----------------------');

        // 直接处理整个 chunk
        String processedChunk = chunk.trim();

        // 如果是 JSON 格式的数据
        if (processedChunk.startsWith('{') && processedChunk.endsWith('}')) {
          print('[AiService] 检测到直接的JSON格式数据');
          yield processedChunk;
          continue;
        }

        // 将整个 chunk 按行分割
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          // 处理以 data: 开头的行
          if (line.startsWith('data:')) {
            final jsonStr = line.substring(5).trim();
            if (jsonStr.isNotEmpty) {
              print('[AiService] 解析到data: $jsonStr');
              yield jsonStr;
            }
          } else if (line.contains('data:')) {
            // 处理可能包含多个 data: 的情况
            final dataSegments = line.split('data:');
            for (final segment in dataSegments) {
              if (segment.trim().isEmpty) continue;

              final jsonStr = segment.trim();
              print('[AiService] 从复合行中解析到data: $jsonStr');
              yield jsonStr;
            }
          } else if (line.startsWith('{') && line.contains('"event"')) {
            // 处理直接的 JSON 格式
            print('[AiService] 检测到行内JSON格式数据: $line');
            yield line;
          }
        }
      }
      print('[AiService] 流式响应结束');
    } catch (e, stack) {
      print('[AiService] streamAnswer error: $e');
      print('[AiService] stack: $stack');
      rethrow;
    }
  }
}
