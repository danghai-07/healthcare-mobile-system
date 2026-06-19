import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/benefit_chip_row.dart';
import '../../../../core/widgets/catalog_hero_banner.dart';

/// Header for health blog catalog.
class BlogCatalogHeader extends StatelessWidget {
  const BlogCatalogHeader({super.key});

  static const _benefits = [
    (Icons.menu_book_outlined, 'Kiến thức'),
    (Icons.tips_and_updates_outlined, 'Mẹo hay'),
    (Icons.update_outlined, 'Cập nhật'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CatalogHeroBanner(
          title: 'Bài viết sức khỏe',
          subtitle: 'Kiến thức chăm sóc sức khỏe giới tính mỗi ngày',
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
                  Icons.article_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Bài viết do chuyên gia biên soạn — dễ hiểu, '
                  'phù hợp cho mọi đối tượng.',
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
