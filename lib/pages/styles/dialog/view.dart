import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class DialogPage extends GetView<DialogController> {
  const DialogPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("DialogPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DialogController>(
      init: DialogController(),
      id: "dialog",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("dialog")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
