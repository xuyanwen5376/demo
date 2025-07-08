import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

// 压缩返回类型
class CompressMediaFile {
  final File? thumbnail;
  final MediaInfo? video;

  CompressMediaFile({
    this.thumbnail,
    this.video,
  });
}

/// 媒体压缩
class DuCompress {
  // 压缩图片
  static Future<File?> image(
    File file, {
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    final xfile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_temp.jpg',
      keepExif: true,
      quality: 80,
      format: CompressFormat.jpeg,
      minHeight: minHeight,
      minWidth: minWidth,
    );
    return xfile == null ? null : File(xfile.path);
  }

  // 压缩视频
  static Future<CompressMediaFile> video(File file) async {
    var result = await Future.wait([
      VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.Res640x480Quality,
        deleteOrigin: false, // 默认不要去删除原视频
        includeAudio: true,
        frameRate: 25,
      ),
      VideoCompress.getFileThumbnail(
        file.path,
        quality: 80,
        position: -1000,
      ),
    ]);
    return CompressMediaFile(
      video: result.first as MediaInfo,
      thumbnail: result.last as File,
    );
  }

  // 清理缓存
  static Future<bool?> clean() async {
    return await VideoCompress.deleteAllCache();
  }

  // 取消
  static Future<void> cancel() async {
    await VideoCompress.cancelCompression();
  }
}
