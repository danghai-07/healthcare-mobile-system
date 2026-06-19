import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../routes/route_names.dart';
import '../../../service/presentation/presenters/service_presenter.dart';
import '../../../service/presentation/presenters/service_view_status.dart';
import '../../../service/presentation/widgets/test_record_card.dart';
import '../presenters/appointment_presenter.dart';
import '../presenters/appointment_view_status.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_catalog_header.dart';

/// Appointment and medical test history for the signed-in member.
class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tab = GoRouterState.of(context).uri.queryParameters['tab'];
      if (tab == 'testRecords') {
        context
            .read<AppointmentPresenter>()
            .setListTab(AppointmentListTab.testRecords);
        context.read<ServicePresenter>().loadTestRecords();
      }
      context.read<AppointmentPresenter>().loadAppointmentHistory();
    });
  }

  Future<void> _onRefresh(AppointmentPresenter presenter) async {
    if (presenter.listTab == AppointmentListTab.consultations) {
      await presenter.refreshHistory();
    } else {
      await context.read<ServicePresenter>().loadTestRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentPresenter>(
      builder: (context, presenter, _) {
        return RefreshIndicator(
          onRefresh: () => _onRefresh(presenter),
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: AppSpacing.screenPadding.copyWith(bottom: 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const AppointmentCatalogHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    SegmentedButton<AppointmentListTab>(
                      segments: const [
                        ButtonSegment(
                          value: AppointmentListTab.consultations,
                          label: Text('Tư vấn'),
                          icon: Icon(Icons.event_note_outlined, size: 18),
                        ),
                        ButtonSegment(
                          value: AppointmentListTab.testRecords,
                          label: Text('Xét nghiệm'),
                          icon: Icon(Icons.biotech_outlined, size: 18),
                        ),
                      ],
                      selected: {presenter.listTab},
                      onSelectionChanged: (values) {
                        final tab = values.first;
                        presenter.setListTab(tab);
                        if (tab == AppointmentListTab.testRecords) {
                          context.read<ServicePresenter>().loadTestRecords();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (presenter.listTab == AppointmentListTab.consultations)
                      _HistoryFilterBar(
                        selected: presenter.historyFilter,
                        onChanged: presenter.setHistoryFilter,
                      )
                    else
                      Consumer<ServicePresenter>(
                        builder: (context, servicePresenter, _) {
                          return _HistoryFilterBar(
                            selected: servicePresenter.testRecordFilter,
                            onChanged: servicePresenter.setTestRecordFilter,
                          );
                        },
                      ),
                  ]),
                ),
              ),
              if (presenter.listTab == AppointmentListTab.consultations)
                _buildConsultationSliver(context, presenter)
              else
                _buildTestRecordSliver(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsultationSliver(
    BuildContext context,
    AppointmentPresenter presenter,
  ) {
    return switch (presenter.listStatus) {
      AppointmentViewStatus.loading || AppointmentViewStatus.idle =>
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: LoadingWidget(message: 'Đang tải lịch hẹn...'),
          ),
        ),
      AppointmentViewStatus.error => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.listErrorMessage ??
                  'Không thể tải lịch sử lịch hẹn.',
              onRetry: presenter.loadAppointmentHistory,
            ),
          ),
        ),
      AppointmentViewStatus.empty => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: EmptyStateWidget(
              title: 'Chưa có lịch hẹn',
              message: presenter.historyFilter == AppointmentHistoryFilter.all
                  ? 'Đặt lịch tư vấn để bắt đầu theo dõi sức khỏe.'
                  : 'Không có lịch hẹn trong mục này.',
              icon: Icons.event_busy_outlined,
              actionLabel: 'Tìm tư vấn viên',
              onAction: () => context.go(RoutePaths.consultants),
            ),
          ),
        ),
      AppointmentViewStatus.success => SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final appointment = presenter.appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                  index: index,
                  onTap: () => context.pushNamed(
                    RouteNames.appointmentDetail,
                    pathParameters: {
                      'id': appointment.appointmentId.toString(),
                    },
                  ),
                );
              },
              childCount: presenter.appointments.length,
            ),
          ),
        ),
    };
  }

  Widget _buildTestRecordSliver(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return switch (presenter.recordsStatus) {
          ServiceViewStatus.loading || ServiceViewStatus.idle =>
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: LoadingWidget(message: 'Đang tải lịch sử...'),
              ),
            ),
          ServiceViewStatus.error => SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: AppErrorWidget(
                  message: presenter.recordsErrorMessage ??
                      'Không thể tải lịch sử xét nghiệm.',
                  onRetry: presenter.loadTestRecords,
                ),
              ),
            ),
          ServiceViewStatus.empty => SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: EmptyStateWidget(
                  title: 'Chưa có lịch sử xét nghiệm',
                  message: presenter.testRecordFilter ==
                          AppointmentHistoryFilter.all
                      ? 'Đặt xét nghiệm để theo dõi kết quả tại đây.'
                      : 'Không có lịch xét nghiệm trong mục này.',
                  icon: Icons.history_toggle_off_outlined,
                  actionLabel: 'Đặt xét nghiệm',
                  onAction: () => context.go(RoutePaths.medicalTests),
                ),
              ),
            ),
          ServiceViewStatus.success => SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final record = presenter.testRecords[index];
                    return TestRecordCard(
                      record: record,
                      index: index,
                      onTap: () => context.pushNamed(
                        RouteNames.appointmentTestRecordDetail,
                        pathParameters: {
                          'recordId': record.testServiceRecordId.toString(),
                        },
                      ),
                    );
                  },
                  childCount: presenter.testRecords.length,
                ),
              ),
            ),
        };
      },
    );
  }
}

class _HistoryFilterBar extends StatelessWidget {
  const _HistoryFilterBar({
    required this.selected,
    required this.onChanged,
  });

  final AppointmentHistoryFilter selected;
  final ValueChanged<AppointmentHistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppointmentHistoryFilter>(
      segments: const [
        ButtonSegment(
          value: AppointmentHistoryFilter.all,
          label: Text('Tất cả'),
        ),
        ButtonSegment(
          value: AppointmentHistoryFilter.upcoming,
          label: Text('Sắp tới'),
        ),
        ButtonSegment(
          value: AppointmentHistoryFilter.past,
          label: Text('Đã qua'),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}
