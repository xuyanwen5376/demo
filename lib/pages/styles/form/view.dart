import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class FormPage extends GetView<FormController> {
  const FormPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("FormPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      init: FormController(),
      id: "form",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("form")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
