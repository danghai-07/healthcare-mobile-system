import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_card.dart';
import 'soft_icon_badge.dart';

/// Tappable feature card for home grids and navigation hubs.
class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.iconBackground,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      showShadow: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          SoftIconBadge(
            icon: icon,
            size: 48,
            iconSize: 24,
            iconColor: iconColor ?? AppColors.primaryDark,
            backgroundColor: iconBackground ?? AppColors.primaryLight,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
