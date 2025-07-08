import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class RadioGroupPage extends GetView<RadioGroupController> {
  const RadioGroupPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("RadioGroupPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RadioGroupController>(
      init: RadioGroupController(),
      id: "radio_group",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("radio_group")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
