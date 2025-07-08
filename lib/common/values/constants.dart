/// 常量
class Constants {
  // wp 服务器
  static const wpApiBaseUrl = 'https://wpapi.ducafecat.tech';
  static const wpApiBaseUrl2 = 'https://videoapi.ducafecat.tech';
  static const wpApiBaseUrl3 = "https://mock.apifox.cn/m1/2249037-0-default";
  static const wpApiBaseUrl4 = "https://erp.bosum.com/erp/phone";
  static const String stsUrl =
      "https://erp.bosum.com/erp/phone/document/privateWirteToken";

  // 本地存储key
  static const storageLanguageCode = 'language_code';
  static const storageAlreadyOpen = 'already_open'; // 首次打开

  // AES
  static const aesKey = 'aH5aH5bG0dC6aA3oN0cK4aU5jU6aK2lN';
  static const aesIV = 'hK6eB4aE1aF3gH5q';

  // 登录成功后 token
  static const storageToken = 'token';
  // 用户资料缓存
  static const storageProfile = 'profile';

  // 首页离线
  static const storageHomeBanner = 'home_banner';
  static const storageHomeCategories = 'home_categories';
  static const storageHomeFlashSell = 'home_flash_sell';
  static const storageHomeNewSell = 'home_new_sell';

  // 基础数据
  // 商品分类
  static const storageProductsCategories = 'home_categories';
  // 颜色定义
  static const storageProductsAttributesColors = 'products_attributes_colors';
  // 尺寸定义
  static const storageProductsAttributesSizes = 'products_attributes_sizes';
  // 品牌
  static const storageProductsAttributesBrand = 'products_attributes_brand';
  // 性别
  static const storageProductsAttributesGender = 'products_attributes_gender';
  // 新旧
  static const storageProductsAttributesCondition =
      'products_attributes_condition';

  // 腾讯 tim app id     ==  ed534e9458d4d6095a7fcc2f5968312e3f5438553d3a0256d89558fd5a05b762
  // eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwlUZiXnpxYl5ULnilOzEgoLMFCUrQzMDAwNLEwsLY4hMakVBZlEqUNzU1NQIKAURLcnMBYmZmxqaGFmam5lDTclMBxodHOznmObnUVkYrB2RVRHo5Z-iV5noZuYdFaOflG-qZVAZ6heoHaPvm5GZZxpqq1QLAGEhMxk_
  static const timAppID =
      1600094880;  // 1400804450; // 1600094883 ;// 1600094880;

  // 图片服务器
  // 图片服务器
  static const imageServer =
      "https://ducafecat.oss-cn-beijing.aliyuncs.com/ducafecat-video-flutter";

  // 图片选取数量
  static const maxAssets = 9;

  // 视频录制最大时间 秒
  static const double maxVideoDuration = 30;

  // OSS endpoint
  static const String ossEndpoint = 'oss-cn-shenzhen.aliyuncs.com';
  // 你的bucket
  static const String bucketName = 'bosum-erp-private-write';
}
