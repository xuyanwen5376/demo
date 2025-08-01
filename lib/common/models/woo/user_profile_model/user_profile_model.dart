import 'billing.dart';
import 'links.dart';
import 'meta_datum.dart';
import 'shipping.dart';

class UserProfileModel {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? username;
  Billing? billing;
  Shipping? shipping;
  bool? isPayingCustomer;
  String? avatarUrl;
  List<MetaDatum>? metaData;
  Links? links;
  String? imSign;
  String? nickName;
  String? avatar;

  UserProfileModel({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.username,
    this.billing,
    this.shipping,
    this.isPayingCustomer,
    this.avatarUrl,
    this.metaData,
    this.links,
    this.imSign,
    this.nickName,
    this.avatar,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // 解析 meta_data
    List<MetaDatum>? metaData =
        (json['meta_data'] as List<dynamic>?)
            ?.map((e) => MetaDatum.fromJson(e as Map<String, dynamic>))
            .toList();

    // 从 meta_data 中查找 im_sign
    String? imSign = json['im_sign'] as String?;
    if (imSign == null && metaData != null) {
      for (var meta in metaData) {
        if (meta.key == 'im_sign') {
          imSign = meta.value;
          break;
        }
      }
    }

    return UserProfileModel(
      id: json['id'] as int?,
      dateCreated: json['date_created'] as String?,
      dateCreatedGmt: json['date_created_gmt'] as String?,
      dateModified: json['date_modified'] as String?,
      dateModifiedGmt: json['date_modified_gmt'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String?,
      username: json['username'] as String?,
      billing:
          json['billing'] == null
              ? null
              : Billing.fromJson(json['billing'] as Map<String, dynamic>),
      shipping:
          json['shipping'] == null
              ? null
              : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      isPayingCustomer: json['is_paying_customer'] as bool?,
      avatarUrl: json['avatar_url'] as String?,
      metaData: metaData,
      links:
          json['_links'] == null
              ? null
              : Links.fromJson(json['_links'] as Map<String, dynamic>),
      imSign: imSign,
      nickName: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_created': dateCreated,
    'date_created_gmt': dateCreatedGmt,
    'date_modified': dateModified,
    'date_modified_gmt': dateModifiedGmt,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'role': role,
    'username': username,
    'billing': billing?.toJson(),
    'shipping': shipping?.toJson(),
    'is_paying_customer': isPayingCustomer,
    'avatar_url': avatarUrl,
    'meta_data': metaData?.map((e) => e.toJson()).toList(),
    '_links': links?.toJson(),
    'im_sign': imSign,
    'nickname': nickName,
    'avatar': avatar,
  };
}
