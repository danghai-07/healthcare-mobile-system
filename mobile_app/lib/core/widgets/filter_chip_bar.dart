import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Horizontal filter chips used across list screens.
class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.allLabel = 'Tất cả',
    this.showAllChip = true,
    this.height = 40,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int?> onSelected;
  final String allLabel;
  final bool showAllChip;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (showAllChip)
            _AppFilterChip(
              label: allLabel,
              selected: selectedIndex == null,
              onTap: () => onSelected(null),
            ),
          for (var i = 0; i < labels.length; i++)
            _AppFilterChip(
              label: labels[i],
              selected: selectedIndex == i,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

/// Topic/specialty filter where selection is the label itself.
class TopicFilterChipBar extends StatelessWidget {
  const TopicFilterChipBar({
    super.key,
    required this.topics,
    required this.selected,
    required this.onChanged,
    this.allLabel = 'Tất cả',
  });

  final List<String> topics;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _AppFilterChip(
            label: allLabel,
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          ...topics.map(
            (topic) => _AppFilterChip(
              label: topic,
              selected: selected == topic,
              onTap: () => onChanged(topic),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppFilterChip extends StatelessWidget {
  const _AppFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryLight,
        checkmarkColor: AppColors.primaryDark,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? AppColors.primaryDark : AppColors.textSecondary,
            ),
      ),
    );
  }
}
