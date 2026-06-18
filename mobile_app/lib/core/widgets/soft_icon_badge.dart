import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft circular icon container — Headspace / Calm inspired.
class SoftIconBadge extends StatelessWidget {
  const SoftIconBadge({
    super.key,
    required this.icon,
    this.size = 56,
    this.iconSize = 28,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? AppColors.primaryDark,
      ),
    );
  }
}
