import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/benefit_chip_row.dart';
import '../../../../core/widgets/catalog_hero_banner.dart';
import '../../../../core/theme/app_colors.dart';

/// Header for appointment history tab.
class AppointmentCatalogHeader extends StatelessWidget {
  const AppointmentCatalogHeader({super.key});

  static const _benefits = [
    (Icons.notifications_active_outlined, 'Nhắc lịch'),
    (Icons.history_rounded, 'Lịch sử'),
    (Icons.fact_check_outlined, 'Chi tiết'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CatalogHeroBanner(
          title: 'Lịch hẹn của tôi',
          subtitle: 'Theo dõi tư vấn và xét nghiệm tại một nơi',
        ),
        const SizedBox(height: AppSpacing.lg),
        const BenefitChipRow(items: _benefits),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          backgroundColor: AppColors.primaryMuted,
          borderColor: AppColors.primaryLight,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.event_available_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Xem lịch sắp tới, lịch đã qua và kết quả xét nghiệm '
                  'trong hai tab bên dưới.',
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
