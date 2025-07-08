import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class CheckboxPage extends GetView<CheckboxController> {
  const CheckboxPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("CheckboxPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckboxController>(
      init: CheckboxController(),
      id: "checkbox",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("checkbox")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
