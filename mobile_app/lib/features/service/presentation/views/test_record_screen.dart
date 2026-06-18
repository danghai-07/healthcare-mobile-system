import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../appointment/presentation/presenters/appointment_view_status.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../routes/route_names.dart';
import '../presenters/service_presenter.dart';
import '../presenters/service_view_status.dart';
import '../widgets/test_record_card.dart';

/// Medical test records history for the signed-in member.
class TestRecordScreen extends StatefulWidget {
  const TestRecordScreen({super.key});

  @override
  State<TestRecordScreen> createState() => _TestRecordScreenState();
}

class _TestRecordScreenState extends State<TestRecordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final presenter = context.read<ServicePresenter>();
      if (presenter.recordsStatus == ServiceViewStatus.idle) {
        presenter.loadTestRecords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return RefreshIndicator(
          onRefresh: presenter.loadTestRecords,
          color: AppColors.primary,
          child: _buildBody(context, presenter),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ServicePresenter presenter) {
    return switch (presenter.recordsStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: LoadingWidget(message: 'Đang tải lịch sử...')),
          ],
        ),
      ServiceViewStatus.error => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          children: [
            AppErrorWidget(
              message: presenter.recordsErrorMessage ??
                  'Không thể tải lịch sử xét nghiệm.',
              onRetry: presenter.loadTestRecords,
            ),
          ],
        ),
      ServiceViewStatus.empty => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: 40),
            EmptyStateWidget(
              title: 'Chưa có lịch sử xét nghiệm',
              message: presenter.testRecordFilter ==
                      AppointmentHistoryFilter.all
                  ? 'Đặt xét nghiệm để theo dõi kết quả tại đây.'
                  : 'Không có lịch xét nghiệm trong mục này.',
              icon: Icons.history_toggle_off_outlined,
              actionLabel: 'Đặt xét nghiệm',
              onAction: () => context.go(RoutePaths.medicalTests),
            ),
          ],
        ),
      ServiceViewStatus.success => ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          itemCount: presenter.testRecords.length,
          itemBuilder: (context, index) {
            final record = presenter.testRecords[index];
            return TestRecordCard(
              record: record,
              onTap: () => context.pushNamed(
                RouteNames.appointmentTestRecordDetail,
                pathParameters: {
                  'recordId': record.testServiceRecordId.toString(),
                },
              ),
            );
          },
        ),
    };
  }
}
