import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/home_process_section.dart';

/// Marketing header for the medical test catalog — hero, benefits, FAQ.
class ServiceCatalogHeader extends StatelessWidget {
  const ServiceCatalogHeader({super.key});

  static const _benefits = [
    (Icons.verified_user_outlined, 'Bảo mật'),
    (Icons.schedule_outlined, 'Đặt lịch nhanh'),
    (Icons.science_outlined, 'Lab chuẩn'),
    (Icons.lock_outline_rounded, 'Riêng tư'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroBanner(),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _benefits.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final (icon, label) = _benefits[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const HomeProcessSection(horizontal: true),
        const SizedBox(height: AppSpacing.lg),
        _InfoExpansion(
          title: 'Xét nghiệm STIs là gì?',
          body:
              'Xét nghiệm STIs giúp phát hiện sớm HIV, lậu, giang mai, chlamydia... '
              'qua mẫu máu, nước tiểu hoặc dịch sinh dục. Xét nghiệm định kỳ rất quan trọng, '
              'kể cả khi không có triệu chứng.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _InfoExpansion(
          title: 'Ai nên xét nghiệm?',
          body: null,
          bullets: const [
            'Đã quan hệ tình dục không an toàn',
            'Có nhiều bạn tình hoặc bạn tình mới',
            'Có triệu chứng nghi ngờ (dịch bất thường, ngứa, đau khi tiểu...)',
            'Bạn tình mắc STIs hoặc đang mang thai',
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          backgroundColor: AppColors.primaryMuted,
          borderColor: AppColors.primaryLight,
          child: Row(
            children: [
              Image.asset(
                AppAssets.secury,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Kết quả được bảo mật — chỉ bạn và nhân viên y tế phụ trách.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.card,
      child: Stack(
        children: [
          Image.asset(
            AppAssets.banner,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.55),
                    AppColors.primaryDark.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xét nghiệm STIs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Phát hiện sớm — bảo vệ sức khỏe của bạn',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.4,
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

class _InfoExpansion extends StatelessWidget {
  const _InfoExpansion({
    required this.title,
    this.body,
    this.bullets,
  });

  final String title;
  final String? body;
  final List<String>? bullets;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.primary,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
          ),
          children: [
            if (body != null)
              Text(
                body!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            if (bullets != null)
              ...bullets!.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          item,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.45,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
