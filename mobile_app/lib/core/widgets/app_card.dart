import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Card container with soft border, optional shadow, and tap feedback.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.showShadow = false,
    this.borderColor,
    this.responsive = false,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final Color? borderColor;
  final bool responsive;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.card;

    Widget content = Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: 1,
        ),
        boxShadow: showShadow ? AppShadows.sm : AppShadows.none,
      ),
      child: Padding(
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.primary.withValues(alpha: 0.06),
          highlightColor: AppColors.primaryLight.withValues(alpha: 0.4),
          child: content,
        ),
      );
    }

    if (responsive) {
      content = Responsive.constrain(context: context, child: content);
    }

    return content;
  }
}
