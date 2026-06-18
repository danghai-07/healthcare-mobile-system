import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'app_card.dart';
import 'secondary_button.dart';
import 'soft_icon_badge.dart';

/// Error state widget with optional retry action.
///
/// Named [AppErrorWidget] because Flutter reserves [ErrorWidget] for the
/// framework error builder.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.title = 'Đã xảy ra lỗi',
    this.onRetry,
    this.retryLabel = 'Thử lại',
    this.icon = Icons.sentiment_dissatisfied_outlined,
    this.compact = false,
    this.responsive = true,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final IconData icon;
  final bool compact;
  final bool responsive;

  @override
  Widget build(BuildContext context) {
    final content = AppCard(
      showShadow: !compact,
      padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SoftIconBadge(
            icon: icon,
            backgroundColor: AppColors.errorLight,
            iconColor: AppColors.error,
            size: compact ? 48 : 64,
            iconSize: compact ? 24 : 32,
          ),
          SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
          Text(
            title,
            style: compact
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xxl),
            SecondaryButton(
              label: retryLabel,
              onPressed: onRetry,
              isExpanded: false,
              responsive: false,
            ),
          ],
        ],
      ),
    );

    final body = compact
        ? content
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: content,
            ),
          );

    if (!responsive) {
      return body;
    }

    return Responsive.constrain(
      context: context,
      child: body,
    );
  }
}

/// Alias for [AppErrorWidget] (Flutter reserves [ErrorWidget]).
typedef ErrorWidget = AppErrorWidget;
