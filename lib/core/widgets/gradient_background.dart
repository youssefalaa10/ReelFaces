import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/colors_manager.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    super.key,
    this.colors,
    this.begin,
    this.end,
  });
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.topCenter,
          end: end ?? Alignment.bottomCenter,
          colors:
              colors ??
              [
                AppColors.cinematicGradientStart,
                AppColors.cinematicGradientEnd,
              ],
        ),
      ),
      child: child,
    );
  }
}

class BlurredBackground extends StatelessWidget {
  const BlurredBackground({
    required this.child,
    super.key,
    this.imageUrl,
    this.blurRadius = 10.0,
  });
  final Widget child;
  final String? imageUrl;
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl != null
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
              child: Container(color: AppColors.overlay, child: child),
            )
          : child,
    );
  }
}
