import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ColorsPage extends GetView<ColorsController> {
  const ColorsPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("ColorsPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ColorsController>(
      init: ColorsController(),
      id: "colors",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("colors")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
