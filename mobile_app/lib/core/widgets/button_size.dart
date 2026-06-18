import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shared button sizes across [PrimaryButton] and [SecondaryButton].
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Internal button styling helpers for the design system.
abstract final class AppButtonStyles {
  static EdgeInsets padding(AppButtonSize size) => switch (size) {
        AppButtonSize.small => const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm + 2,
          ),
        AppButtonSize.medium => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md + 2,
          ),
        AppButtonSize.large => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxxl,
            vertical: AppSpacing.lg,
          ),
      };

  static TextStyle textStyle(AppButtonSize size) => switch (size) {
        AppButtonSize.small => AppTextStyles.labelLarge,
        AppButtonSize.medium => AppTextStyles.button,
        AppButtonSize.large => AppTextStyles.titleMedium,
      };

  static double iconSize(AppButtonSize size) => switch (size) {
        AppButtonSize.small => 16,
        AppButtonSize.medium => 18,
        AppButtonSize.large => 20,
      };

  static double loadingSize(AppButtonSize size) => switch (size) {
        AppButtonSize.small => 18,
        AppButtonSize.medium => 22,
        AppButtonSize.large => 24,
      };

  static ButtonStyle applySize(ButtonStyle style, AppButtonSize size) {
    return style.copyWith(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStatePropertyAll(padding(size)),
      minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
      textStyle: WidgetStatePropertyAll(textStyle(size)),
    );
  }

  static Widget buildLabel({
    required String label,
    IconData? icon,
    required AppButtonSize size,
  }) {
    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize(size)),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  static Widget buildLoading({
    required Color color,
    required AppButtonSize size,
  }) {
    final dimension = loadingSize(size);
    return SizedBox(
      height: dimension,
      width: dimension,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
