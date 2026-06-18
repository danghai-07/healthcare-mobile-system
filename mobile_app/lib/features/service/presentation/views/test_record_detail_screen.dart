import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../appointment/presentation/widgets/appointment_card.dart';
import '../../domain/entities/medical_service.dart';
import '../presenters/service_presenter.dart';
import '../presenters/service_view_status.dart';

/// Full test record detail — list cards show basic info only.
class TestRecordDetailScreen extends StatefulWidget {
  const TestRecordDetailScreen({
    super.key,
    required this.recordId,
    this.showBookedMessage = false,
  });

  final int recordId;
  final bool showBookedMessage;

  @override
  State<TestRecordDetailScreen> createState() => _TestRecordDetailScreenState();
}

class _TestRecordDetailScreenState extends State<TestRecordDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicePresenter>().loadTestRecordDetail(widget.recordId);
      if (widget.showBookedMessage && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Đặt xét nghiệm thành công!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  Future<void> _cancelRecord(ServicePresenter presenter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy lịch xét nghiệm'),
        content: const Text(
          'Bạn có chắc muốn hủy lịch xét nghiệm này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy lịch'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await presenter.cancelTestRecord(widget.recordId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chi tiết xét nghiệm',
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isCancelling,
            message: 'Đang hủy lịch...',
            child: _buildBody(presenter),
          ),
        );
      },
    );
  }

  Widget _buildBody(ServicePresenter presenter) {
    return switch (presenter.recordDetailStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải...')),
      ServiceViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.recordDetailErrorMessage ??
                  'Không thể tải chi tiết xét nghiệm.',
              onRetry: () =>
                  presenter.loadTestRecordDetail(widget.recordId),
            ),
          ),
        ),
      ServiceViewStatus.success => _buildContent(context, presenter),
      ServiceViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(BuildContext context, ServicePresenter presenter) {
    final record = presenter.testRecordDetail;
    if (record == null) {
      return const SizedBox.shrink();
    }

    final canCancel = record.status != null &&
        !record.status!.toLowerCase().contains('cancel') &&
        !record.status!.toLowerCase().contains('hủy') &&
        !record.status!.toLowerCase().contains('completed');

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            showShadow: true,
            child: Row(
              children: [
                const SoftIcon(icon: Icons.biotech_outlined),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.serviceName ?? 'Xét nghiệm',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Mã hồ sơ #${record.testServiceRecordId}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (record.status != null && record.status!.isNotEmpty)
                  AppointmentStatusBadge(status: record.status!),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(
            title: 'Thông tin lịch xét nghiệm',
            responsive: false,
          ),
          AppCard(
            child: Column(
              children: [
                if (record.testDate != null)
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Ngày xét nghiệm',
                    value: _formatDate(record.testDate!),
                  ),
                if (record.timeSlot != null &&
                    record.timeSlot!.isNotEmpty) ...[
                  if (record.testDate != null)
                    const Divider(height: AppSpacing.xxl),
                  _DetailRow(
                    icon: Icons.schedule_outlined,
                    label: 'Ca',
                    value: _formatTimeSlot(record.timeSlot!),
                  ),
                ],
                if (record.recordDate != null) ...[
                  const Divider(height: AppSpacing.xxl),
                  _DetailRow(
                    icon: Icons.event_available_outlined,
                    label: 'Ngày đặt',
                    value: _formatDate(record.recordDate!),
                  ),
                ],
              ],
            ),
          ),
          if (_hasPatientInfo(record)) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Thông tin bệnh nhân',
              responsive: false,
            ),
            AppCard(
              child: Column(
                children: [
                  if (record.fullNameOfMember != null &&
                      record.fullNameOfMember!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Họ tên',
                      value: record.fullNameOfMember!,
                    ),
                  if (record.dob != null) ...[
                    if (record.fullNameOfMember != null &&
                        record.fullNameOfMember!.isNotEmpty)
                      const Divider(height: AppSpacing.xxl),
                    _DetailRow(
                      icon: Icons.cake_outlined,
                      label: 'Ngày sinh',
                      value: _formatDate(record.dob!),
                    ),
                  ],
                  if (record.gender != null && record.gender!.isNotEmpty) ...[
                    const Divider(height: AppSpacing.xxl),
                    _DetailRow(
                      icon: Icons.wc_outlined,
                      label: 'Giới tính',
                      value: record.gender!,
                    ),
                  ],
                  if (record.phoneNumber != null &&
                      record.phoneNumber!.isNotEmpty) ...[
                    const Divider(height: AppSpacing.xxl),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Số điện thoại',
                      value: record.phoneNumber!,
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (record.staffName != null && record.staffName!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Nhân viên phụ trách',
              responsive: false,
            ),
            AppCard(
              child: _DetailRow(
                icon: Icons.medical_services_outlined,
                label: 'Nhân viên',
                value: record.staffName!,
              ),
            ),
          ],
          if (record.result != null && record.result!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Kết quả', responsive: false),
            AppCard(
              backgroundColor: AppColors.successLight,
              borderColor: AppColors.success.withValues(alpha: 0.3),
              child: Text(
                record.result!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
            ),
          ],
          if (record.notes != null && record.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Ghi chú', responsive: false),
            AppCard(child: Text(record.notes!)),
          ],
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.xxxl),
            SecondaryButton(
              label: 'Hủy lịch xét nghiệm',
              onPressed: presenter.isCancelling
                  ? null
                  : () => _cancelRecord(presenter),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static bool _hasPatientInfo(TestServiceRecord record) {
    return (record.fullNameOfMember != null &&
            record.fullNameOfMember!.isNotEmpty) ||
        record.dob != null ||
        (record.gender != null && record.gender!.isNotEmpty) ||
        (record.phoneNumber != null && record.phoneNumber!.isNotEmpty);
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
