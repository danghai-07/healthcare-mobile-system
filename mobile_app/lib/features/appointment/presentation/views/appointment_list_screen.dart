import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../../../service/presentation/presenters/service_presenter.dart';
import '../../../service/presentation/views/test_record_screen.dart';
import '../presenters/appointment_presenter.dart';
import '../presenters/appointment_view_status.dart';
import '../widgets/appointment_card.dart';

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
      }
      context.read<AppointmentPresenter>().loadAppointmentHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentPresenter>(
      builder: (context, presenter, _) {
        return Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding.copyWith(bottom: 0),
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Lịch hẹn của tôi',
                    subtitle:
                        'Theo dõi lịch tư vấn và lịch sử đặt xét nghiệm.',
                    responsive: false,
                  ),
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
                      presenter.setListTab(values.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            Expanded(
              child: presenter.listTab == AppointmentListTab.consultations
                  ? _ConsultationHistoryTab(presenter: presenter)
                  : const TestRecordScreen(),
            ),
          ],
        );
      },
    );
  }
}

class _ConsultationHistoryTab extends StatelessWidget {
  const _ConsultationHistoryTab({required this.presenter});

  final AppointmentPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: presenter.refreshHistory,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildBodySliver(context),
        ],
      ),
    );
  }

  Widget _buildBodySliver(BuildContext context) {
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
          padding: AppSpacing.screenPadding.copyWith(top: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final appointment = presenter.appointments[index];
                return AppointmentCard(
                  appointment: appointment,
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
