// ignore_for_file: avoid_print

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../index.dart';
import 'index.dart';

/// 预览类型
enum GalleryType { assets, urls, video }

// 图片视频预览
class GalleryWidget extends StatefulWidget {
  const GalleryWidget({
    super.key,
    required this.initialIndex,
    this.items,
    this.isBarVisible,
    this.timeline,
    this.imgUrls,
    this.onActionsPressed,
  });

  /// 初始图片位置
  final int initialIndex;

  /// AssetEntity 图片列表
  final List<AssetEntity>? items;

  /// URL 图片列表
  final List<String>? imgUrls;

  /// 是否显示 bar
  final bool? isBarVisible;

  /// 动态信息
  final TimelineModel? timeline;

  /// 右侧点击事件
  final Function()? onActionsPressed;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  // 是否显示 bar
  bool _isShowAppBar = true;

  // 当前页码
  int _currentPage = 0;

  // video 视频控制器
  VideoPlayerController? _videoController;

  // chewie 控制器
  ChewieController? _chewieController;

  // 预览类型
  GalleryType _galleryType = GalleryType.assets;

  // 当系统将应用程序置于后台或返回时调用 应用程序到前台。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("didChangeAppLifecycleState: $state");
    if (_videoController?.value.isInitialized != true) return;
    // 该应用程序当前对用户不可见，不响应 用户输入，并在后台运行。
    if (state != AppLifecycleState.paused) {
      _chewieController?.pause();
    }
    // 该应用程序是可见的并响应用户输入。
    if (state != AppLifecycleState.resumed) {
      _chewieController?.play();
    }
  }

  // 在此 [State] 对象的依赖项更改时调用。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoutePages.observer.subscribe(
      this,
      ModalRoute.of(context) as PageRoute,
    ); // 订阅路由
  }

  // 当由A打开B页面时，B页面调起该方法；
  @override
  void didPush() {
    super.didPush();
    print("didPush");
  }

  // 在C页面关闭后，B页面调起该方法；
  @override
  void didPushNext() {
    super.didPushNext();
    print("didPushNext");
    if (_videoController?.value.isInitialized != true) return;
    _chewieController?.pause();
  }

  // 当B页面关闭时，B页面调起该方法；
  @override
  void didPop() {
    super.didPop();
    print("didPop");
  }

  // 当从B页面打开C页面时，该方法被调起。
  @override
  void didPopNext() {
    super.didPopNext();
    print("didPopNext");
    if (_videoController?.value.isInitialized != true) return;
    _chewieController?.play();
  }

  @override
  void initState() {
    super.initState();

    // 阅览类型
    _galleryType = GalleryType.assets;
    // 视频
    if (widget.timeline?.postType == "2") {
      _galleryType = GalleryType.video;
    }
    // 发布选取的相册图片 AssetEntiry
    else if (widget.items != null) {
      _galleryType = GalleryType.assets;
    }
    // url 图片列表
    else if (widget.imgUrls != null) {
      _galleryType = GalleryType.urls;
    }

    // 是否显示 bar
    _isShowAppBar = widget.isBarVisible ?? true;

    // 当前页码
    _currentPage = widget.initialIndex + 1;

    // 将给定对象注册为绑定观察者。捆绑 当各种应用程序事件发生时，观察者会收到通知， 例如，当系统区域设置更改时。
    WidgetsBinding.instance.addObserver(this);

    // 在下一帧之后调用回调。如果在帧绘制之前调用，则回调将在下一帧中调用。
    WidgetsBinding.instance.addPostFrameCallback((_) => _onLoadVideo());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    RoutePages.observer.unsubscribe(this);
    _videoController?.dispose();
    _chewieController?.dispose();
    _videoController = null;
    _chewieController = null;
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////////

  // 初始加载视频
  Future<void> _onLoadVideo() async {
    if (widget.timeline?.postType != "2") {
      return Future.value();
    }

    try {
      // video_player 初始化
      _videoController = VideoPlayerController.network(
        widget.timeline?.video?.url ?? "",
      );

      // 尝试打开给定的 [dataSource] 并加载有关视频的元数据。
      await _videoController?.initialize();

      // chewie 初始化
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        autoInitialize: true,
        showOptions: false,
        // 用于 iOS 控件的颜色。默认情况下，iOS 播放器使用 从原始 iOS 11 设计中采样的颜色。
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: AppColors.secondary,
        ),
        // 用于 material 进度条的颜色。默认情况下，材质播放器使用主题中的颜色。
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.secondary,
        ),
        // 定义是否应显示播放速度控件
        allowPlaybackSpeedChanging: false,
        // 定义进入全屏时允许的设备方向集
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
        ],
        // 定义退出全屏后允许的设备方向集
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        // 占位组件
        placeholder:
            _videoController?.value.isInitialized != true
                ? Image.network(
                  DuTools.imageUrlFormat(
                    widget.timeline?.video?.cover ?? "",
                    width: 400,
                  ),
                  fit: BoxFit.cover,
                )
                : null,
      );
    } catch (e) {
      DuToast.show('Video url load error.');
    } finally {
      if (mounted) setState(() {});
    }
  }

  ///////////////////////////////////

  // 导航栏 - 选相册
  PostAppBarWidget _buildPublishNav(int pages) {
    return PostAppBarWidget(
      isAnimated: true,
      isShow: _isShowAppBar,
      title: Text(
        "$_currentPage / $pages",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: widget.onActionsPressed ?? () {},
            child: const Text("发布"),
          ),
        ),
      ],
    );
  }

  // 导航栏 - 图片 url 列表
  PostAppBarWidget _buildPreviewNav(int pages) {
    return PostAppBarWidget(
      isAnimated: true,
      isShow: _isShowAppBar,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日期
          Text(
            widget.timeline?.publishDate ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          // 页码页数
          if (widget.timeline?.postType == "1")
            Text(
              "$_currentPage / $pages",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
      ),
      actions: [
        GestureDetector(
          onTap:
              widget.onActionsPressed ??
              () {
                // 导航压入新界面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text("新界面")),
                        body: const Center(child: Text("新界面")),
                      );
                    },
                  ),
                );
              },
          child: Padding(
            padding: EdgeInsets.only(right: AppSpace.page),
            child: Icon(Icons.more_horiz_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // 图片视图
  Widget _buildImageView() {
    return ExtendedImageGesturePageView.builder(
      controller: ExtendedPageController(initialPage: widget.initialIndex),
      itemCount: widget.items?.length ?? 0,
      onPageChanged: (value) {
        setState(() {
          _currentPage = value + 1;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final AssetEntity asset = widget.items![index];
        return ExtendedImage(
          image: AssetEntityImageProvider(asset, isOriginal: true),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true,
            );
          },
        );
      },
    );
  }

  // URL 图片视图
  Widget _buildImageByUrlsView() {
    return ExtendedImageGesturePageView.builder(
      controller: ExtendedPageController(initialPage: widget.initialIndex),
      itemCount: widget.imgUrls?.length ?? 0,
      onPageChanged: (value) {
        setState(() {
          _currentPage = value + 1;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final String src = widget.imgUrls![index];
        return ExtendedImage(
          image: ExtendedNetworkImageProvider(
            DuTools.imageUrlFormat(src, width: 700),
          ),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true,
            );
          },
        );
      },
    );
  }

  // 动态栏
  Widget? _buildTimelineBar(bool isShow) {
    TimelineModel? timeline = widget.timeline;
    int likesCount = timeline?.likes?.length ?? 0;
    int commentsCount = timeline?.comments?.length ?? 0;

    if (isShow == false || timeline == null) {
      return null;
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 内容
          Padding(
            padding: EdgeInsets.all(AppSpace.appbar),
            child: Text(timeline.content ?? "", style: textStyleDetail),
          ),

          // 点赞数、评论，详情
          Container(
            color: Colors.black,
            padding: EdgeInsets.only(
              left: AppSpace.listItem,
              right: AppSpace.listItem,
              top: AppSpace.listItem,
              bottom: AppSpace.listItem * 2,
            ),
            child: Row(
              children: [
                // like 图标
                if (likesCount > 0)
                  const Icon(
                    Icons.favorite_border_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                const SpaceHorizontalWidget(space: 5),

                // like 数量
                if (likesCount > 0) Text("$likesCount", style: textStyleDetail),
                const SpaceHorizontalWidget(),

                // 评论 图标
                if (commentsCount > 0)
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 24,
                    color: Colors.white,
                  ),
                const SpaceHorizontalWidget(space: 5),

                // 评论 文字
                if (commentsCount > 0)
                  Text("评论($commentsCount)", style: textStyleDetail),
                const Spacer(),

                // 详情按钮
                GestureDetector(
                  onTap: () {},
                  child: Text("详情 >", style: textStyleDetail),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // 视频视图
  Widget _buildVideoView() {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.grey[100],
          child: Container(
            decoration: const BoxDecoration(color: Colors.black),
            child:
                _chewieController == null
                    ? Text(
                      "视频载入中 loading...",
                      style: textStyleDetail,
                      textAlign: TextAlign.center,
                    )
                    : Chewie(controller: _chewieController!),
          ),
        ),
      ),
    );
  }

  // 主视图
  Widget _mainView() {
    Widget body = const Text("loading...");
    switch (_galleryType) {
      case GalleryType.assets:
        body = _buildImageView();
        break;
      case GalleryType.video:
        body = _buildVideoView();
        break;
      case GalleryType.urls:
        body = _buildImageByUrlsView();
        break;
    }

    // 数量
    int itemsCount = widget.items?.length ?? widget.imgUrls?.length ?? 0;

    return GestureDetector(
      // 不许穿透
      behavior: HitTestBehavior.opaque,
      // 点击返回
      onTap: () => setState(() => _isShowAppBar = !_isShowAppBar),
      // onTap: () => Navigator.pop(context),
      child: Scaffold(
        // 全屏, 高度将扩展为包括应用栏的高度
        extendBodyBehindAppBar: true,

        // 背景黑色
        backgroundColor: Colors.black,

        // 导航栏
        appBar:
            _galleryType == GalleryType.assets
                ? _buildPublishNav(itemsCount)
                : _buildPreviewNav(itemsCount),

        // 图片浏览
        body: body,

        // 底部视图
        bottomSheet: _buildTimelineBar(_isShowAppBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
