import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

mixin RefreshMixin<T extends GetxController> on GetxController {
  // 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  // 分页参数
  int page = 1;
  final int limit = 20;
  bool hasMore = true;

  /// 子类必须实现：分页数据加载
  Future<List> loadPageData({required int page, required int limit});

  /// 子类必须实现：刷新后如何处理数据
  void onDataRefreshed(List data);

  /// 子类必须实现：加载更多后如何处理数据
  void onDataLoaded(List data);

  /// 刷新
  Future<void> onRefresh() async {
    page = 1;
    hasMore = true; 
    try {
      final data = await loadPageData(page: page, limit: limit); 
      onDataRefreshed(data); 
      if (data.length < limit) {
        hasMore = false;
        refreshController.loadNoData(); 
      } else {
        hasMore = true; 
      }
      refreshController.refreshCompleted();
    } catch (e) { 
      refreshController.refreshFailed();
    }
  }

  /// 加载更多
  Future<void> onLoading() async {
    if (!hasMore) {
      refreshController.loadNoData();
      return;
    }
    try {
      final data = await loadPageData(page: page + 1, limit: limit);
      if (data.isEmpty) {
        hasMore = false;
        refreshController.loadNoData();
      } else {
        page++;
        onDataLoaded(data);
        if (data.length < limit) {
          hasMore = false;
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
    } catch (e) {
      refreshController.loadFailed();
    }
  }
}
