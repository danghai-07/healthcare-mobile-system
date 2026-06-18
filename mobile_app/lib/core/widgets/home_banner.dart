import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Promotional banner shown on the home dashboard.
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 2.4,
        child: Image.asset(
          AppAssets.banner,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, _, _) => Container(
            color: AppColors.primaryMuted,
            alignment: Alignment.center,
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
