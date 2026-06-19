import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Quick navigation shortcuts on the profile screen.
class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({super.key});

  static const _actions = [
    (
      Icons.event_note_outlined,
      'Lịch hẹn',
      RoutePaths.appointments,
    ),
    (
      Icons.biotech_outlined,
      'Xét nghiệm',
      RoutePaths.medicalTests,
    ),
    (
      Icons.article_outlined,
      'Bài viết',
      RoutePaths.blogs,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_actions.length, (index) {
        final (icon, label, route) = _actions[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < _actions.length - 1 ? AppSpacing.sm : 0,
            ),
            child: AppCard(
              onTap: () => context.go(route),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
