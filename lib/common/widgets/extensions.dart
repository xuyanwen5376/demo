import 'package:flutter/material.dart';

extension SliverPaddingExtension on Widget {
  Widget sliverPaddingHorizontal(double value) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: value),
      sliver: this,
    );
  }
}
