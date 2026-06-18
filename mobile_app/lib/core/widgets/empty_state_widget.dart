import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'app_card.dart';
import 'primary_button.dart';
import 'soft_icon_badge.dart';

/// Empty state widget for lists and content areas.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.responsive = true,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
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
            size: compact ? 48 : 64,
            iconSize: compact ? 24 : 30,
          ),
          SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
          Text(
            title,
            style: compact
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xxl),
            PrimaryButton(
              label: actionLabel!,
              onPressed: onAction,
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
