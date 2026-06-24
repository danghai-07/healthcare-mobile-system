import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/doctor_avatar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/appointment.dart';
import '../presenters/appointment_presenter.dart';
import '../presenters/appointment_view_status.dart';
import '../widgets/appointment_card.dart';

/// Full appointment detail loaded from `GET /api/Appointment/detail/{id}`.
class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({
    super.key,
    required this.appointmentId,
  });

  final int appointmentId;

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AppointmentPresenter>()
          .loadAppointmentDetail(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chi tiết lịch hẹn',
          showBackButton: true,
          body: _buildBody(presenter),
        );
      },
    );
  }

  Widget _buildBody(AppointmentPresenter presenter) {
    return switch (presenter.detailStatus) {
      AppointmentViewStatus.loading || AppointmentViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải chi tiết...')),
      AppointmentViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.detailErrorMessage ??
                  'Không thể tải chi tiết lịch hẹn.',
              onRetry: () =>
                  presenter.loadAppointmentDetail(widget.appointmentId),
            ),
          ),
        ),
      AppointmentViewStatus.success => _buildContent(presenter.appointmentDetail),
      AppointmentViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(AppointmentDetail? detail) {
    if (detail == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            showShadow: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DoctorAvatar(
                      name: detail.consultantName ?? 'Tư vấn viên',
                      radius: 36,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.consultantName ?? 'Tư vấn viên',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Mã lịch hẹn #${detail.appointmentId}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    AppointmentStatusBadge(status: detail.status),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(
            title: 'Thông tin lịch hẹn',
            accentTitle: true,
            responsive: false,
          ),
          AppCard(
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Ngày',
                  value: _formatDate(detail.startTime),
                ),
                const Divider(height: AppSpacing.xxl),
                _DetailRow(
                  icon: Icons.schedule_outlined,
                  label: 'Thời gian',
                  value:
                      '${_formatTime(detail.startTime)} – ${_formatTime(detail.endTime)}',
                ),
                if (detail.serviceName != null &&
                    detail.serviceName!.isNotEmpty) ...[
                  const Divider(height: AppSpacing.xxl),
                  _DetailRow(
                    icon: Icons.medical_services_outlined,
                    label: 'Dịch vụ',
                    value: detail.serviceName!,
                  ),
                ],
              ],
            ),
          ),
          if (detail.memberName != null && detail.memberName!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Thông tin thành viên',
              accentTitle: true,
              responsive: false,
            ),
            AppCard(
              child: _DetailRow(
                icon: Icons.person_outline_rounded,
                label: 'Họ tên',
                value: detail.memberName!,
              ),
            ),
          ],
          if (detail.symptoms != null &&
              detail.symptoms!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Triệu chứng',
              accentTitle: true,
              responsive: false,
            ),
            AppCard(
              child: Text(
                detail.symptoms!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
            ),
          ],
          if (detail.meetLink != null && detail.meetLink!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Link tư vấn',
              accentTitle: true,
              responsive: false,
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText(
                    detail.meetLink!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: () => _copyMeetLink(context, detail.meetLink!),
                    icon: const Icon(Icons.link_rounded, size: 18),
                    label: const Text('Sao chép link'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _copyMeetLink(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép link tư vấn'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _formatDate(DateTime dateTime) {
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
