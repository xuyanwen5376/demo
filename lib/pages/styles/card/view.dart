import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class CardPage extends GetView<CardController> {
  const CardPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("CardPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      init: CardController(),
      id: "card",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("card")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
