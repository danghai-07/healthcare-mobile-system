import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/doctor_avatar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../../domain/entities/consultant.dart';
import '../presenters/consultant_presenter.dart';
import '../presenters/consultant_view_status.dart';

/// Consultant profile screen — booking via [RouteNames.consultantSlotSelection].
class ConsultantDetailScreen extends StatefulWidget {
  const ConsultantDetailScreen({
    super.key,
    required this.consultantId,
  });

  final int consultantId;

  @override
  State<ConsultantDetailScreen> createState() => _ConsultantDetailScreenState();
}

class _ConsultantDetailScreenState extends State<ConsultantDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsultantPresenter>().loadConsultantDetail(widget.consultantId);
    });
  }

  void _openSlotSelection() {
    context.pushNamed(
      RouteNames.consultantSlotSelection,
      pathParameters: {'id': widget.consultantId.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultantPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chi tiết tư vấn viên',
          showBackButton: true,
          body: _buildBody(presenter),
        );
      },
    );
  }

  Widget _buildBody(ConsultantPresenter presenter) {
    return switch (presenter.detailStatus) {
      ConsultantViewStatus.loading || ConsultantViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải thông tin...')),
      ConsultantViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.detailErrorMessage ??
                  'Không thể tải thông tin tư vấn viên.',
              onRetry: () =>
                  presenter.loadConsultantDetail(widget.consultantId),
            ),
          ),
        ),
      ConsultantViewStatus.success => _buildContent(presenter.consultantDetail),
      ConsultantViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(ConsultantDetail? detail) {
    if (detail == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileHeader(detail: detail),
          const SizedBox(height: AppSpacing.xxl),
          if (detail.specialties.isNotEmpty) ...[
            const SectionHeader(
              title: 'Chuyên khoa',
              responsive: false,
            ),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: detail.specialties
                  .where((s) => (s.name ?? '').isNotEmpty)
                  .map(
                    (specialty) => Chip(
                      label: Text(specialty.name!),
                      backgroundColor: AppColors.primaryLight,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppColors.primaryDark),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
          if (detail.weeklySchedules.isNotEmpty) ...[
            const SectionHeader(
              title: 'Lịch làm việc',
              subtitle: 'Khung giờ tư vấn trong tuần.',
              responsive: false,
            ),
            AppCard(
              child: Column(
                children: detail.weeklySchedules.map((schedule) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            '${_dayLabel(schedule.dayOfWeek)} · '
                            '${schedule.startTime} – ${schedule.endTime}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
          PrimaryButton(
            label: 'Đặt lịch tư vấn',
            icon: Icons.calendar_today_rounded,
            onPressed: _openSlotSelection,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static String _dayLabel(int dayOfWeek) {
    return switch (dayOfWeek) {
      0 => 'Chủ nhật',
      1 => 'Thứ 2',
      2 => 'Thứ 3',
      3 => 'Thứ 4',
      4 => 'Thứ 5',
      5 => 'Thứ 6',
      6 => 'Thứ 7',
      _ => 'Ngày $dayOfWeek',
    };
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.detail});

  final ConsultantDetail detail;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: true,
      child: Row(
        children: [
          DoctorAvatar(
            avatarUrl: detail.avatar,
            gender: detail.gender,
            name: detail.fullName,
            radius: 36,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
