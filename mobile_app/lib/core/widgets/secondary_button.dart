import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'button_size.dart';

/// Secondary action button — soft green surface or outlined style.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.outlined = true,
    this.responsive = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;

  /// When `true`, renders an outlined button. When `false`, soft filled surface.
  final bool outlined;
  final bool responsive;

  @override
  Widget build(BuildContext context) {
    final Widget button;

    if (outlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.applySize(
          OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            disabledForegroundColor: AppColors.textDisabled,
            side: const BorderSide(color: AppColors.borderStrong),
          ),
          size,
        ),
        child: _buildChild(),
      );
    } else {
      button = FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.applySize(
          FilledButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primaryDark,
            disabledBackgroundColor: AppColors.surfaceVariant,
            disabledForegroundColor: AppColors.textTertiary,
          ),
          size,
        ),
        child: _buildChild(),
      );
    }

    Widget result = isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;

    if (responsive) {
      result = Responsive.constrain(
        context: context,
        maxWidth: Responsive.maxFormWidth,
        child: result,
      );
    }

    return result;
  }

  Widget _buildChild() {
    if (isLoading) {
      return AppButtonStyles.buildLoading(
        color: AppColors.primary,
        size: size,
      );
    }

    return AppButtonStyles.buildLabel(
      label: label,
      icon: icon,
      size: size,
    );
  }
}
