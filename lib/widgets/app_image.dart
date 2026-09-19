import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

class AppImageAsset extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const AppImageAsset({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppSpacing.radiusMd),
    ),
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(assetPath, fit: fit),
        ),
      ),
    );
  }
}
