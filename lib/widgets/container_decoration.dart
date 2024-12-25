import 'package:flutter/material.dart';
import 'package:retail_app/themes/themes.dart';

class ContainerDecoration {
  static decoration({
    double? height,
    double? width,
    Color? bColor,
    Color? color,
    BorderRadiusGeometry? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      border: Border.all(color: bColor ?? borderColor),
      borderRadius: borderRadius ?? BorderRadius.circular(5.0),
    );
  }
}
