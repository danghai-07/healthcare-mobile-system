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
  });

  final TestServiceRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      showShadow: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SoftIcon(icon: Icons.biotech_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  record.serviceName ?? 'Xét nghiệm',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (record.status != null && record.status!.isNotEmpty)
                AppointmentStatusBadge(status: record.status!),
            ],
          ),
          if (record.testDate != null) ...[
            const SizedBox(height: AppSpacing.md),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: _formatDate(record.testDate!),
            ),
          ],
          if (record.timeSlot != null && record.timeSlot!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            _InfoRow(
              icon: Icons.schedule_outlined,
              text: _formatTimeSlot(record.timeSlot!),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String _formatTimeSlot(String slot) {
    final parts = slot.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return slot;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }
}
