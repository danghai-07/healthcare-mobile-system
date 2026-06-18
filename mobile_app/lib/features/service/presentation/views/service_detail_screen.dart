import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../presenters/service_presenter.dart';
import '../presenters/service_view_status.dart';

/// Medical test service detail from `GET /api/Service/{id}`.
class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  final int serviceId;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicePresenter>().loadServiceDetail(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chi tiết dịch vụ',
          showBackButton: true,
          body: _buildBody(context, presenter),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ServicePresenter presenter) {
    return switch (presenter.detailStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải...')),
      ServiceViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.detailErrorMessage ??
                  'Không thể tải chi tiết dịch vụ.',
              onRetry: () =>
                  presenter.loadServiceDetail(widget.serviceId),
            ),
          ),
        ),
      ServiceViewStatus.success => _buildContent(context, presenter),
      ServiceViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(BuildContext context, ServicePresenter presenter) {
    final service = presenter.serviceDetail;
    if (service == null) {
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
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Icon(
                        Icons.science_outlined,
                        color: AppColors.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Text(
                        service.name ?? 'Dịch vụ xét nghiệm',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                if (service.price != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _formatPrice(service.price!),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (service.description != null &&
              service.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Mô tả dịch vụ',
              responsive: false,
            ),
            AppCard(
              child: Text(
                service.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
          PrimaryButton(
            label: 'Đặt xét nghiệm',
            icon: Icons.calendar_today_rounded,
            onPressed: () => context.pushNamed(
              RouteNames.medicalTestBooking,
              pathParameters: {'id': widget.serviceId.toString()},
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} đ';
  }
}
