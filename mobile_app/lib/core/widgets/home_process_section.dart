import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';
import 'section_header.dart';

/// Four-step test process section distilled from web Home.
class HomeProcessSection extends StatelessWidget {
  const HomeProcessSection({
    super.key,
    this.horizontal = false,
  });

  /// When true, four steps in one row (service catalog).
  final bool horizontal;

  static const _steps = [
    (AppAssets.testProcess1, 'Đặt lịch', 'Chọn gói xét nghiệm phù hợp'),
    (AppAssets.testProcess2, 'Lấy mẫu', 'Đến cơ sở theo lịch hẹn'),
    (AppAssets.testProcess3, 'Phân tích', 'Xét nghiệm tại phòng lab'),
    (AppAssets.testProcess4, 'Kết quả', 'Nhận kết quả bảo mật'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Quy trình xét nghiệm',
          subtitle: '4 bước đơn giản, an toàn',
          accentTitle: true,
          responsive: false,
        ),
        const SizedBox(height: AppSpacing.md),
        if (horizontal)
          _HorizontalSteps(steps: _steps)
        else
          ...List.generate(_steps.length, (index) {
            final (asset, title, desc) = _steps[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _steps.length - 1 ? AppSpacing.sm : 0,
              ),
              child: _VerticalStepCard(
                index: index,
                asset: asset,
                title: title,
                description: desc,
              ),
            );
          }),
      ],
    );
  }
}

class _VerticalStepCard extends StatelessWidget {
  const _VerticalStepCard({
    required this.index,
    required this.asset,
    required this.title,
    required this.description,
  });

  final int index;
  final String asset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              asset,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. $title',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalSteps extends StatelessWidget {
  const _HorizontalSteps({required this.steps});

  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final (asset, title, _) = steps[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < steps.length - 1 ? AppSpacing.xs : 0,
            ),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          asset,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
