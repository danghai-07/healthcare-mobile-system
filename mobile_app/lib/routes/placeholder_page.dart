import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/app_scaffold.dart';
import '../core/widgets/soft_icon_badge.dart';

/// Consistent placeholder for features under development.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.layers_outlined,
    this.showBackButton = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      showBackButton: showBackButton,
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: AppCard(
            showShadow: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SoftIconBadge(
                  icon: icon,
                  size: 64,
                  iconSize: 30,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Sắp ra mắt',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
