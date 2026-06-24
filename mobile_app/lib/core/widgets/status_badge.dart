import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Semantic status pill used on cards (appointments, test records).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
  });

  final String label;
  final Color? color;
  final Color? backgroundColor;

  factory StatusBadge.pending(String label) => StatusBadge(
        label: label,
        color: AppColors.warning,
        backgroundColor: AppColors.warningLight,
      );

  factory StatusBadge.success(String label) => StatusBadge(
        label: label,
        color: AppColors.success,
        backgroundColor: AppColors.successLight,
      );

  factory StatusBadge.error(String label) => StatusBadge(
        label: label,
        color: AppColors.error,
        backgroundColor: AppColors.errorLight,
      );

  factory StatusBadge.info(String label) => StatusBadge(
        label: label,
        color: AppColors.primary,
        backgroundColor: AppColors.primaryMuted,
      );

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.textSecondary;
    final bg = backgroundColor ?? AppColors.surfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
