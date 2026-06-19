import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../appointment/presentation/widgets/appointment_card.dart';
import '../../domain/entities/medical_service.dart';

/// Compact list card — basic info only; see detail screen for full data.
class TestRecordCard extends StatelessWidget {
  const TestRecordCard({
    super.key,
    required this.record,
    required this.onTap,
    this.index = 0,
  });

  final TestServiceRecord record;
  final VoidCallback onTap;
  final int index;

  static const _headerTints = [
    AppColors.primaryMuted,
    AppColors.primaryLight,
    Color(0xFFE0F2F1),
  ];

  @override
  Widget build(BuildContext context) {
    final headerTint = _headerTints[index % _headerTints.length];

    return AppCard(
      onTap: onTap,
      showShadow: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: headerTint,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                if (record.testDate != null)
                  _DateBadge(date: record.testDate!)
                else
                  const SoftIcon(icon: Icons.biotech_outlined),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    record.serviceName ?? 'Xét nghiệm',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (record.status != null && record.status!.isNotEmpty)
                  AppointmentStatusBadge(status: record.status!),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                if (record.timeSlot != null && record.timeSlot!.isNotEmpty) ...[
                  const Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Ca ${_formatTimeSlot(record.timeSlot!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ] else
                  Expanded(
                    child: Text(
                      'Lịch xét nghiệm',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                Text(
                  'Chi tiết',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTimeSlot(String slot) {
    final parts = slot.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return slot;
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Text(
            date.day.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
          ),
          Text(
            'T${date.month}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
