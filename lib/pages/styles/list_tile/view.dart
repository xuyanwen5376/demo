import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ListTilePage extends GetView<ListTileController> {
  const ListTilePage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("ListTilePage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListTileController>(
      init: ListTileController(),
      id: "list_tile",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("list_tile")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
