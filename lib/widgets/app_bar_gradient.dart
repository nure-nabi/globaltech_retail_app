import 'package:flutter/material.dart';
import 'package:retail_app/themes/themes.dart';

class AppBarGradient {
  static appBarDecoration({
    List<Color>? colors,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ??
            [
              primaryColor,
              Colors.orange,
            ],
        begin: begin,
        end: end,
      ),
    );
  }
}
