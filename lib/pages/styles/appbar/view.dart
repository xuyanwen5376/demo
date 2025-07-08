import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class AppbarPage extends GetView<AppbarController> {
  const AppbarPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("AppbarPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppbarController>(
      init: AppbarController(),
      id: "appbar",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("appbar")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
