import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/feature_tile.dart';
import '../../../../core/widgets/home_process_section.dart';
import '../../../../core/widgets/home_banner.dart';
import '../../../../core/widgets/section_header.dart';

/// Home dashboard with quick access to main features.
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeBanner(),
            const SizedBox(height: AppSpacing.xxl),
            const _WelcomeHeader(),
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Dịch vụ của bạn',
              subtitle: 'Mọi thứ bạn cần, trong tầm tay',
              accentTitle: true,
            ),
            FeatureTile(
              title: 'Đặt lịch tư vấn',
              subtitle: 'Kết nối với chuyên gia sức khỏe',
              icon: Icons.calendar_month_rounded,
              onTap: () => context.go(RoutePaths.consultants),
            ),
            const SizedBox(height: AppSpacing.md),
            FeatureTile(
              title: 'Lịch hẹn của tôi',
              subtitle: 'Xem và quản lý cuộc hẹn',
              icon: Icons.event_available_rounded,
              onTap: () => context.go(RoutePaths.appointments),
            ),
            const SizedBox(height: AppSpacing.md),
            FeatureTile(
              title: 'Xét nghiệm',
              subtitle: 'Đặt và theo dõi kết quả',
              icon: Icons.biotech_rounded,
              onTap: () => context.go(RoutePaths.medicalTests),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const HomeProcessSection(),
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Bảo mật thông tin',
              subtitle: 'Dữ liệu sức khỏe được bảo vệ nghiêm ngặt',
              accentTitle: true,
            ),
            AppCard(
              showShadow: true,
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.secury,
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      'Mọi thông tin xét nghiệm và tư vấn được mã hóa, '
                      'chỉ bạn và bác sĩ phụ trách có quyền truy cập.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(
              title: 'Gợi ý hôm nay',
              accentTitle: true,
            ),
            AppCard(
              showShadow: true,
              backgroundColor: AppColors.primaryMuted,
              borderColor: AppColors.primaryLight,
              child: Row(
                children: [
                  const BrandLogo(
                    size: LogoSize.small,
                    showWordmark: false,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đọc bài viết sức khỏe',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Kiến thức chăm sóc sức khỏe giới tính mỗi ngày.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextButton(
                          onPressed: () => context.go(RoutePaths.blogs),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Khám phá ngay'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: true,
      backgroundColor: AppColors.surface,
      child: Row(
        children: [
          const BrandLogo(
            size: LogoSize.small,
            showWordmark: false,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào 👋',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Chăm sóc sức khỏe giới tính — mỗi ngày cùng bạn.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
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
