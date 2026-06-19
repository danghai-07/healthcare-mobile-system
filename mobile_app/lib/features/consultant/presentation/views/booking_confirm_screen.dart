import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/soft_icon_badge.dart';

/// Confirmation screen after a successful consultant or medical test booking.
class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({
    super.key,
    this.appointmentId,
    this.recordId,
  });

  final String? appointmentId;
  final String? recordId;

  bool get _isMedicalTest => recordId != null;

  String get _subtitle {
    if (_isMedicalTest) {
      return 'Mã đặt xét nghiệm: #$recordId';
    }
    if (appointmentId != null) {
      return 'Mã lịch hẹn: #$appointmentId';
    }
    return 'Lịch tư vấn của bạn đã được ghi nhận.';
  }

  void _openAppointments(BuildContext context) {
    if (_isMedicalTest) {
      context.go('${RoutePaths.appointments}?tab=testRecords');
      return;
    }
    context.go(RoutePaths.appointments);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SoftIconBadge(
              icon: Icons.check_circle_rounded,
              size: 72,
              iconSize: 40,
              backgroundColor: AppColors.primaryMuted,
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              _isMedicalTest
                  ? 'Đặt xét nghiệm thành công!'
                  : 'Đặt lịch thành công!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            PrimaryButton(
              label: 'Xem lịch hẹn',
              icon: Icons.event_note_outlined,
              onPressed: () => _openAppointments(context),
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: 'Về trang chủ',
              onPressed: () => context.go(RoutePaths.home),
            ),
          ],
        ),
      ),
    );
  }
}
