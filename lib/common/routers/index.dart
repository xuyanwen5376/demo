library;

export 'names.dart';
export 'pages.dart';
export 'observers.dart';

  // 视频
  GetPage(
    name: RouteNames.tiktok,
    page: () => const TiktokPage(),
    binding: TiktokBinding(),
  ),

  // 视频详情
  GetPage(
    name: RouteNames.tiktokDetail,
    page: () => const TiktokDetailPage(),
    binding: TiktokDetailBinding(),
  ),
  