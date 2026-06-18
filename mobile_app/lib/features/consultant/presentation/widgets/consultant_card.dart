import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/doctor_avatar.dart';
import '../../domain/entities/consultant.dart';

/// List tile card for a consultant with avatar, specialties, and availability hint.
class ConsultantCard extends StatelessWidget {
  const ConsultantCard({
    super.key,
    required this.consultant,
    required this.onTap,
  });

  final Consultant consultant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final specialtyText = consultant.specialties
        .map((s) => s.name)
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .join(' · ');

    final nextSlot = consultant.freeSlots.isNotEmpty
        ? consultant.freeSlots.first
        : null;

    return AppCard(
      onTap: onTap,
      showShadow: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorAvatar(
            avatarUrl: consultant.avatar,
            gender: consultant.gender,
            name: consultant.fullName,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.fullName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  consultant.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                if (specialtyText.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: consultant.specialties
                        .where((s) => (s.name ?? '').isNotEmpty)
                        .take(3)
                        .map(
                          (specialty) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              specialty.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.primaryDark),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (nextSlot != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Còn trống ${_formatTime(nextSlot.start)}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
