import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

enum MediaType { video, image }

class MediaItem {
  final String url;
  final MediaType type;
  MediaItem({required this.url, required this.type});
}

class TiktokController extends GetxController {
  TiktokController();

  final List<MediaItem> mediaList = [
    MediaItem(
      url: 'https://www.w3schools.com/w3images/lights.jpg',
      type: MediaType.image,
    ),
    MediaItem(
      url: 'https://www.w3schools.com/w3images/fjords.jpg',
      type: MediaType.image,
    ),
    MediaItem(
      url:
          'https://1305154771.vod2.myqcloud.com/0733b1e4vodcq1305154771/9e274118387702302919994622/lqIn98EBK54A.mp4',
      type: MediaType.video,
    ),
    MediaItem(
      url:
          'https://1305154771.vod2.myqcloud.com/0733b1e4vodcq1305154771/e87c00eb3701925919902529832/mMLD69w3WvkA.mp4',
      type: MediaType.video,
    ),
  ];

  final RxInt currentIndex = 0.obs;

  final Map<int, VideoPlayerController> controllers = {};

  _initData() {
    update(["tiktok"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    onInitController(0);
  }

  void onInitController(int index) {
    final item = mediaList[index];
    if (item.type != MediaType.video) return;
    if (controllers.containsKey(index)) return;
    final ctrl = VideoPlayerController.network(item.url);
    ctrl.initialize().then((_) {
      ctrl.setLooping(true);
      if (index == currentIndex.value) ctrl.play();
      update(["tiktok"]);
    });
    controllers[index] = ctrl;
  }

  void onPageChanged(int index) {
    // 暂停上一个视频
    controllers[currentIndex.value]?.pause();

    currentIndex.value = index;
    onInitController(index);
    controllers[index]?.play();
    update(["tiktok"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    for (var controller in controllers.values) {
      try {
        controller.dispose();
      } catch (_) {}
    }
    super.onClose();
  }
}
