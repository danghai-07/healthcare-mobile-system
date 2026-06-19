import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/search_bar.dart' show AppSearchBar;
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../presenters/service_presenter.dart';
import '../presenters/service_view_status.dart';
import '../widgets/service_card.dart';
import '../widgets/service_catalog_header.dart';

/// Medical test service catalog.
class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicePresenter>().loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          body: RefreshIndicator(
            onRefresh: presenter.loadServices,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: AppSpacing.screenPadding.copyWith(bottom: 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const ServiceCatalogHeader(),
                      const SizedBox(height: AppSpacing.xxl),
                      SectionHeader(
                        title: 'Gói xét nghiệm',
                        subtitle: presenter.listStatus ==
                                ServiceViewStatus.success
                            ? '${presenter.services.length} dịch vụ có sẵn'
                            : 'Chọn gói phù hợp với nhu cầu của bạn',
                        accentTitle: true,
                        responsive: false,
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        actionLabel: 'Lịch sử',
                        actionIcon: Icons.history_rounded,
                        onAction: () => context.go(
                          '${RoutePaths.appointments}?tab=testRecords',
                        ),
                      ),
                      AppSearchBar(
                        hint: 'Tìm dịch vụ xét nghiệm...',
                        onChanged: presenter.setSearchQuery,
                        responsive: false,
                      ),
                    ]),
                  ),
                ),
                _buildBodySliver(context, presenter),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodySliver(
    BuildContext context,
    ServicePresenter presenter,
  ) {
    return switch (presenter.listStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: LoadingWidget(message: 'Đang tải dịch vụ...'),
          ),
        ),
      ServiceViewStatus.error => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.listErrorMessage ??
                  'Không thể tải danh sách dịch vụ.',
              onRetry: presenter.loadServices,
            ),
          ),
        ),
      ServiceViewStatus.empty => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: EmptyStateWidget(
              title: 'Không tìm thấy dịch vụ',
              message: presenter.searchQuery.isNotEmpty
                  ? 'Thử từ khóa tìm kiếm khác.'
                  : 'Hiện chưa có dịch vụ xét nghiệm.',
              icon: Icons.search_off_outlined,
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
                final service = presenter.services[index];
                return ServiceCard(
                  service: service,
                  index: index,
                  onTap: () => context.pushNamed(
                    RouteNames.medicalTestDetail,
                    pathParameters: {
                      'id': service.serviceId.toString(),
                    },
                  ),
                );
              },
              childCount: presenter.services.length,
            ),
          ),
        ),
    };
  }
}
