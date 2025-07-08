 import '../index.dart';
 
/// 朋友圈 api
class TimelineApi {
  /// 翻页列表
  static Future<List<TimelineModel>> pageList() async {
    var res = await WPHttpService.to.get('/timeline/news');

    List<TimelineModel> items = [];
    for (var item in res.data) {
      items.add(TimelineModel.fromJson(item));
    }
    return items;
  }

  /// 点赞
  static Future like(String id) async {
    var res =
        await WPHttpService.to.post('/timeline/$id/like', data: {});
    return res;
  }

  /// 评论
  static Future comment(String id, String content) async {
    var res = await WPHttpService.to.post(
      '/timeline/$id/comment',
      data: {'content': content},
    );
    return res;
  }
}
