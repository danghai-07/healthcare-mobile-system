import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SectionHeader(
                        title: 'Dịch vụ xét nghiệm',
                        subtitle: 'Chọn dịch vụ và đặt lịch xét nghiệm.',
                        responsive: false,
                      ),
                      AppSearchBar(
                        hint: 'Tìm dịch vụ xét nghiệm...',
                        onChanged: presenter.setSearchQuery,
                        responsive: false,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ]),
                  ),
                ),
                _buildBodySliver(presenter),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodySliver(ServicePresenter presenter) {
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
          padding: AppSpacing.screenPadding.copyWith(top: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = presenter.services[index];
                return ServiceCard(
                  service: service,
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
