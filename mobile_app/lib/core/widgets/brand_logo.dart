import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Brand mark using the bundled logo asset.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = LogoSize.medium,
    this.showWordmark = true,
  });

  final LogoSize size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (size) {
      LogoSize.small => 48.0,
      LogoSize.medium => 72.0,
      LogoSize.large => 96.0,
    };

    final titleStyle = switch (size) {
      LogoSize.small => AppTextStyles.titleSmall,
      LogoSize.medium => AppTextStyles.titleLarge,
      LogoSize.large => AppTextStyles.headlineMedium,
    };

    final subtitleStyle = switch (size) {
      LogoSize.small => AppTextStyles.labelMedium,
      LogoSize.medium => AppTextStyles.bodyMedium,
      LogoSize.large => AppTextStyles.titleMedium,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.sm,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            AppAssets.logo,
            fit: BoxFit.cover,
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Chăm sóc',
            style: titleStyle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Sức khỏe Giới tính',
            style: subtitleStyle.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

enum LogoSize { small, medium, large }
