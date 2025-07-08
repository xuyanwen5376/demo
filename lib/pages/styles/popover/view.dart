import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PopoverPage extends GetView<PopoverController> {
  const PopoverPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PopoverPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopoverController>(
      init: PopoverController(),
      id: "popover",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("popover")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
