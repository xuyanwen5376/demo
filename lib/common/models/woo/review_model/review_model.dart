import 'links.dart';

class ReviewModel {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  int? productId;
  String? status;
  String? reviewer;
  String? reviewerEmail;
  String? review;
  int? rating;
  bool? verified;
  Map? reviewerAvatarUrls;
  Links? links;
  List<String>? reviewImages;

  ReviewModel({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.productId,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.rating,
    this.verified,
    this.reviewerAvatarUrls,
    this.links,
    this.reviewImages,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'] as int?,
    dateCreated: json['date_created'] as String?,
    dateCreatedGmt: json['date_created_gmt'] as String?,
    productId: json['product_id'] as int?,
    status: json['status'] as String?,
    reviewer: json['reviewer'] as String?,
    reviewerEmail: json['reviewer_email'] as String?,
    review: json['review'] as String?,
    rating: json['rating'] as int?,
    verified: json['verified'] as bool?,
    reviewImages:
        json['review_images'] == null
            ? [
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/718Y%2BhJkMgL._AC_UY695_.jpg",
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/71n8Tg2ClZL._AC_UY695_.jpg",
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/819mEKajDML._AC_UY695_.jpg",
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/81J0UFuJHdL._AC_UY695_.jpg",
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/81M4BxGW4TL._AC_UY695_.jpg",
              "https://ducafecat.oss-cn-beijing.aliyuncs.com/bag/81s6OXEsZCL._AC_UY695_.jpg",
            ]
            : (json['review_images'] as List).map((e) => e as String).toList(),
    reviewerAvatarUrls:
        json['reviewer_avatar_urls'] == null
            ? null
            : json['reviewer_avatar_urls'] as Map,
    links:
        json['_links'] == null
            ? null
            : Links.fromJson(json['_links'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_created': dateCreated,
    'date_created_gmt': dateCreatedGmt,
    'product_id': productId,
    'status': status,
    'reviewer': reviewer,
    'reviewer_email': reviewerEmail,
    'review': review,
    'rating': rating,
    'verified': verified,
    'reviewer_avatar_urls': reviewerAvatarUrls,
    '_links': links?.toJson(),
    'review_images': reviewImages,
  };
}
