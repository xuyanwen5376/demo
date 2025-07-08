import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class AvatarPage extends GetView<AvatarController> {
  const AvatarPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("AvatarPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AvatarController>(
      init: AvatarController(),
      id: "avatar",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("avatar")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
