import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Responsive layout helpers for widgets.
abstract final class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;
  static const double maxContentWidth = 560;
  static const double maxFormWidth = 480;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Constrains child width on larger screens while staying full-width on phones.
  static Widget constrain({
    required BuildContext context,
    required Widget child,
    double maxWidth = maxContentWidth,
    bool enabled = true,
  }) {
    if (!enabled) {
      return child;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }

  static EdgeInsets screenPadding(BuildContext context) {
    final horizontal = isTablet(context) ? AppSpacing.xxl : AppSpacing.lg;
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: AppSpacing.xxl,
    );
  }
}
