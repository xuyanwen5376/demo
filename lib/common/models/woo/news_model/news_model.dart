class NewsModel {
  int? id;
  String? title;
  String? subtitle;
  String? url;
  String? collectionCount;

  NewsModel({
    this.id,
    this.title,
    this.subtitle,
    this.url,
    this.collectionCount,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    subtitle: json['subtitle'] as String?,
    url: json['url'] as String?,
    collectionCount: json['collection_count'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'url': url,
    'collection_count': collectionCount,
  };

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, subtitle: $subtitle, url: $url, collectionCount: $collectionCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsModel &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.url == url &&
        other.collectionCount == collectionCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        url.hashCode ^
        collectionCount.hashCode;
  }
}
