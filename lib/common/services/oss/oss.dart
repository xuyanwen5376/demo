import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../index.dart';
import 'package:path/path.dart' as path;

/// 阿里云OSS上传服务，自动获取STS临时凭证并上传文件/图片
class ClientSeivice extends GetxService {
  /// 单例对象
  static ClientSeivice get to => Get.find();

  String _accessKeyId = '';
  String _accessKeySecret = '';
  String _stsToken = '';

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 初始化 OSS 客户端
  /// [ossEndpoint] OSS 端点（可选，默认 Constants.ossEndpoint）
  /// [bucketName] OSS 存储桶（可选，默认 Constants.bucketName）
  /// [dio] 自定义 Dio 实例（可选）
  Future<ClientSeivice> init({
    String? ossEndpoint,
    String? bucketName,
    Dio? dio,
  }) async {
    final au = await _authGetter();
    Client.init(
      ossEndpoint: ossEndpoint ?? Constants.ossEndpoint,
      bucketName: bucketName ?? Constants.bucketName,
      dio: dio ?? Dio(BaseOptions(connectTimeout: Duration(seconds: 9000))),
      authGetter: () => au,
    );
    return this;
  }

  /// 获取 OSS 认证信息
  /// 可根据实际业务扩展参数
  Future<Auth> _authGetter() async {
    var options = BaseOptions(
      connectTimeout: const Duration(seconds: 10), // 10000, // 10秒
      receiveTimeout: const Duration(seconds: 5), // 5000, // 5秒
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
      headers: {
        'userPhoneToken':
            'bc0606fb6f9141718a18e67ae2353519@@5d5efa9dd6544c5db846ae5f50a876b6',
        'newToken':
            'eyJhbGciOiJIUzUxMiJ9.eyJhZ2VuY3lJZCI6IjIiLCJ1c2VySWQiOiJiYzA2MDZmYjZmOTE0MTcxOGExOGU2N2FlMjM1MzUxOSIsInVzZXJDb2RlIjoiQjA0MTQxIiwidXNlck5hbWUiOiLosK3nu7TmlY8iLCJkZXB0SWQiOiJkNGM0MDgyN2FjNjc0MDE3OTRkZTQ1ZmM5ZWEzMTZjNSIsImlzU3VwZXIiOmZhbHNlLCJpc01hbmFnZXIiOnRydWUsInVzZXJfa2V5IjoiNThkMzAxODEtZTM5MS00ZjA0LThhZWUtNzdiNDEwYmU2ZWYyIiwiQ0xJRU5UX1RZUEUiOiJBUFAifQ.Lys30vsiPAJkbNhN-RUBN3lVorowl6VBwTsXEyakOBLfpLRFBU-_r7BWEDLr7WBgx0OPqSlukIeaeD64rLkRYQ',
        'Clienttype': 'APP',
      },
    );

    var dio = Dio(options);

    var res = await dio.get(Constants.stsUrl);
    print('STS接口返回数据: ${res.data}');
    final data = res.data;
    if (data is Map &&
        data['success'] == true &&
        data['dataList'] is List &&
        data['dataList'].isNotEmpty) {
      final reslut = data['dataList'][0] ?? {};
      print('STS接口返回第一个元素: $reslut');
      _accessKeyId = reslut['accessKeyId'] ?? '';
      _accessKeySecret = reslut['accessKeySecret'] ?? '';
      _stsToken = reslut['stsToken'] ?? '';
    } else {
      throw Exception('STS接口返回数据异常，data:  ${res.data}');
    }

    if (_accessKeyId.isEmpty || _accessKeySecret.isEmpty || _stsToken.isEmpty) {
      throw Exception('STS接口返回字段缺失');
    }

    return Auth(
      accessKey: _accessKeyId,
      accessSecret: _accessKeySecret,
      expire: DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      secureToken: _stsToken,
    );
  }

  /// 上传内存字节内容
  /// [bytes] 文件字节内容
  /// [objectKey] OSS 文件名
  /// [option] 上传选项（可选）
  Future<dynamic> uploadBytes(
    List<int> bytes,
    String objectKey, {
    PutRequestOption? option,
  }) async {
    return await Client().putObject(bytes, objectKey, option: option);
  }

  /// 上传本地文件
  /// [localPath] 本地文件路径
  /// [fileKey] OSS 文件名（可选）
  /// [option] 上传选项（可选）
  Future<dynamic> uploadFileFromLocal(
    String localPath, {
    String? fileKey,
    PutRequestOption? option,
  }) async {
    return await Client().putObjectFile(
      localPath,
      fileKey: fileKey,
      option: option,
    );
  }

  /// 批量上传本地文件
  /// [fileList] 本地文件路径列表
  /// [fileKeys] OSS 文件名列表（可选，需与 fileList 一一对应）
  /// [option] 上传选项（可选）
  Future<dynamic> batchUploadFileFromLocal(
    List<String> fileList, {
    List<String>? fileKeys,
    PutRequestOption? option,
  }) async {
    final List<AssetFileEntity> entities = [];
    for (int i = 0; i < fileList.length; i++) {
      entities.add(
        AssetFileEntity(
          filepath: fileList[i],
          filename:
              fileKeys != null && i < fileKeys.length ? fileKeys[i] : null,
          option: option,
        ),
      );
    }
    return await Client().putObjectFiles(entities);
  }

  /// 批量上传本地文件并返回公网url列表
  /// [fileList] 本地文件路径列表
  /// [fileKeys] OSS 文件名列表（可选，需与 fileList 一一对应）
  /// [option] 上传选项（可选）
  Future<List<String>> batchUploadAndGetUrls(
    List<String> fileList, {
    List<String>? fileKeys,
    PutRequestOption? option,
  }) async {
    List<String> urls = [];
    for (int i = 0; i < fileList.length; i++) {
      final filePath = fileList[i];
      final fileKey =
          fileKeys != null && i < fileKeys.length ? fileKeys[i] : null;
      final result = await uploadFileFromLocal(
        filePath,
        fileKey: fileKey,
        option: option,
      );
      print('单个上传返回: $result');
      String? objectKey;
      if (result is Map && result['objectKey'] != null) {
        objectKey = result['objectKey'];
      } else if (fileKey != null) {
        objectKey = fileKey;
      } else {
        objectKey = path.basename(filePath);
      }
      if (objectKey != null) {
        urls.add(
          "https://${Constants.bucketName}.${Constants.ossEndpoint}/$objectKey",
        );
      }
    }
    return urls;
  }

  /// 下载OSS文件到内存
  /// [objectKey] OSS 文件名
  /// [onReceiveProgress] 下载进度回调（可选）
  Future<dynamic> downloadFile(
    String objectKey, {
    ProgressCallback? onReceiveProgress,
  }) async {
    return await Client().getObject(
      objectKey,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// 检查OSS文件是否存在
  /// [objectKey] OSS 文件名
  Future<bool> checkFileExist(String objectKey) async {
    return await Client().doesObjectExist(objectKey);
  }

  /// 下载OSS文件并保存到本地
  /// [objectKey] OSS 文件名
  /// [savePath] 本地保存路径
  /// [onReceiveProgress] 下载进度回调（可选）
  Future<dynamic> downloadFileAndSave(
    String objectKey,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    return await Client().downloadObject(
      objectKey,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// 删除OSS文件
  /// [objectKey] OSS 文件名
  Future<void> deleteFile(String objectKey) async {
    await Client().deleteObject(objectKey);
  }

  /// 批量删除OSS文件
  /// [objectKeys] OSS 文件名列表
  Future<void> batchDeleteFile(List<String> objectKeys) async {
    await Client().deleteObjects(objectKeys);
  }

  /// 获取已签名的文件url
  /// [objectKey] OSS 文件名
  /// [params] 额外参数（如图片处理等，可选）
  Future<String> getSignedUrl(
    String objectKey, {
    Map<String, String>? params,
  }) async {
    return await Client().getSignedUrl(objectKey, params: params);
  }

  /// 获取多个已签名的文件url
  /// [objectKeys] OSS 文件名列表
  Future<Map<String, String>> batchGetSignedUrl(List<String> objectKeys) async {
    return await Client().getSignedUrls(objectKeys);
  }

  /// 获取bucket信息
  Future<dynamic> getBucketInfo() async {
    return await Client().getBucketInfo();
  }

  /// 获取bucket的储容量以及文件数量
  Future<dynamic> getBucketStat() async {
    return await Client().getBucketStat();
  }
}
