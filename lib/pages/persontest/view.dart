import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PersontestPage extends GetView<PersontestController> {
  const PersontestPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PersontestPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersontestController>(
      init: PersontestController(),
      id: "persontest",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("persontest")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
