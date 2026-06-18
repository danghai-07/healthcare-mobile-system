import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/doctor_avatar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/appointment.dart';

/// Status badge for appointment cards and detail.
class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final (Color bg, Color fg) = switch (normalized) {
      'completed' || 'done' || 'hoàn thành' => (
          AppColors.successLight,
          AppColors.success,
        ),
      'cancelled' || 'canceled' || 'đã hủy' => (
          AppColors.errorLight,
          AppColors.error,
        ),
      'pending' || 'scheduled' || 'chờ' => (
          AppColors.warningLight,
          AppColors.warning,
        ),
      _ => (AppColors.primaryLight, AppColors.primaryDark),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.chip,
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// List card for an appointment in history.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  final Appointment appointment;
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
              DoctorAvatar(
                name: appointment.consultantName ?? 'Tư vấn viên',
                radius: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  appointment.consultantName ?? 'Tư vấn viên',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              AppointmentStatusBadge(status: appointment.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            text: _formatDateTime(appointment.startTime),
          ),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            icon: Icons.schedule_outlined,
            text:
                '${_formatTime(appointment.startTime)} – ${_formatTime(appointment.endTime)}',
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day/$month/${dateTime.year}';
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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

class SoftIcon extends StatelessWidget {
  const SoftIcon({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: AppColors.primaryDark, size: 20),
    );
  }
}
