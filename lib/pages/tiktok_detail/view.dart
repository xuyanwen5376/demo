import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/index.dart';
import 'index.dart';

class TiktokDetailPage extends GetView<TiktokDetailController> {
  const TiktokDetailPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题部分
          TextWidget.h3(
            "科技巨头Q4财报超预期，AI投资持续加码",
            weight: FontWeight.bold,
          ).paddingHorizontal(16.w),

          SizedBox(height: 16.w),

          // 时间和来源
          Row(
            children: [
              TextWidget.label("2小时前", color: Colors.grey),
              SizedBox(width: 8.w),
              TextWidget.label("·", color: Colors.grey),
              SizedBox(width: 8.w),
              TextWidget.label("科技财经日报", color: Colors.grey),
            ],
          ).paddingHorizontal(16.w),

          SizedBox(height: 20.w),

          // 图片区域
          Container(
            width: double.infinity,
            height: 220.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: ImageWidget.img(
                AssetsImages.homePlaceholderPng,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 20.w),

          // 正文内容
          TextWidget.body(
            "多家科技公司发布Q4财报，营收和利润均超市场预期。其中，AI相关业务成为主要增长驱动力，各公司纷纷加大AI基础设施投资。分析师认为，这一趋势将在2024年持续，为相关产业链带来新机遇。",
            maxLines: 20,
          ).paddingHorizontal(16.w),

          SizedBox(height: 20.w),

          Divider(height: 1, color: Colors.grey.shade200),

          // 详细分析部分
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.label("**详细分析**", weight: FontWeight.bold),
                SizedBox(height: 12.w),
                TextWidget.body(
                  "根据最新发布的行业数据显示，相关领域正在经历前所未有的变革期。多位行业专家表示，这一趋势将持续影响整个产业链，各公司纷纷加速战略布局，以期在新一轮技术革命中抢占先机。\n\n"
                  "英伟达(NVIDIA)财报显示，数据中心业务收入同比增长279%，达到140亿美元，远超分析师预期。公司CEO黄仁勋表示，AI计算需求持续增长，预计未来几个季度供应仍将紧张。\n\n"
                  "微软(Microsoft)云业务Azure增长31%，其中AI服务贡献显著。CEO萨提亚·纳德拉强调，公司正加速将AI集成到所有产品线中，Copilot服务获得积极市场反馈。\n\n"
                  "谷歌母公司Alphabet第四季度云计算业务收入同比增长26%，达到91亿美元。公司表示，生成式AI服务已为超过70%的生成式AI初创独角兽企业提供支持。",
                  maxLines: null,
                ),

                SizedBox(height: 24.w),

                TextWidget.label("**行业展望**", weight: FontWeight.bold),
                SizedBox(height: 12.w),
                TextWidget.body(
                  "摩根士丹利分析师在最新研报中指出，AI相关支出将在2024年继续加速，预计全球企业在AI基础设施上的投资将达到1200亿美元，较2023年增长50%。\n\n"
                  "高盛集团预测，生成式AI将在未来十年为全球GDP贡献约7万亿美元的增长，相当于美国经济总量的1/3。报告特别强调了AI在提升劳动生产率方面的潜力。\n\n"
                  "国内方面，多家投资机构一致看好AI产业链的投资机会，特别是在高性能计算芯片、大模型训练、企业级AI应用等细分领域。",
                  maxLines: null,
                ),

                SizedBox(height: 24.w),

                TextWidget.label("**投资建议**", weight: FontWeight.bold),
                SizedBox(height: 12.w),
                TextWidget.body(
                  "考虑到AI技术的快速发展和广阔应用前景，投资者可关注以下几个方向：\n\n"
                  "1. AI芯片及算力基础设施提供商\n"
                  "2. 大模型开发及应用服务企业\n"
                  "3. 具备数据优势的行业领先企业\n"
                  "4. AI应用落地较快的垂直领域\n\n"
                  "风险提示：技术发展不及预期、政策监管趋严、竞争加剧等因素可能影响行业发展节奏。",
                  maxLines: null,
                ),
              ],
            ),
          ),

          // 相关推荐
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.title3("相关推荐", weight: FontWeight.bold),
                SizedBox(height: 16.w),

                // 相关新闻列表
                ...List.generate(
                  3,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 16.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.w),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // 左侧图片
                        Container(
                          width: 80.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            image: const DecorationImage(
                              image: AssetImage(
                                AssetsImages.homePlaceholderPng,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // 右侧文本
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget.body(
                                "AI大模型技术突破：新算法将训练成本降低40%",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                weight: FontWeight.w500,
                              ),
                              SizedBox(height: 4.w),
                              TextWidget.label(
                                "5小时前 · 科技前沿",
                                color: Colors.grey,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 底部间距
          SizedBox(height: 60.w),
        ],
      ),
    );
  }

  // 底部操作栏
  Widget _buildBottomBar() {
    return Container(
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -1),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧评论输入框
          Expanded(
            child: Container(
              height: 36.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18.w),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18.w,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8.w),
                  TextWidget.label("写评论...", color: Colors.grey),
                ],
              ),
            ),
          ),

          // 右侧操作按钮
          Row(
            children: [
              // AI解读按钮
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: controller.analyzeWithAI,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: TextWidget.label(
                    'AI解读',
                    color: Colors.redAccent,
                    weight: FontWeight.bold,
                    size: 12,
                  ),
                ),
              ),

              // 收藏按钮
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: controller.toggleFavorite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.isFavorite ? Icons.star : Icons.star_border,
                      color:
                          controller.isFavorite
                              ? Colors.redAccent
                              : Colors.grey.shade700,
                      size: 22.w,
                    ),
                    SizedBox(height: 2.w),
                    TextWidget.muted("${controller.favoriteCount}", size: 12),
                  ],
                ),
              ),

              // 分享按钮
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: controller.shareContent,
                child: Icon(
                  Icons.share,
                  color: Colors.grey.shade700,
                  size: 22.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TiktokDetailController>(
      init: TiktokDetailController(),
      id: "tiktok_detail",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("详情"),
            leading: IconWidget.icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              onTap: () => Get.back(),
            ),
            actions: [
              IconWidget.icon(
                Icons.video_collection_rounded,
                size: 25,
              ).paddingRight(AppSpace.page),
            ],
          ),
          body: _buildView(),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }
}
