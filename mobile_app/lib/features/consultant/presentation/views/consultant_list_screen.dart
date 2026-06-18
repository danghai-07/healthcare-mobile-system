import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/search_bar.dart' show AppSearchBar;
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../../domain/entities/specialty.dart';
import '../presenters/consultant_presenter.dart';
import '../presenters/consultant_view_status.dart';
import '../widgets/consultant_card.dart';

/// Horizontal specialty filter chips for the consultant list.
class SpecialtyFilterBar extends StatelessWidget {
  const SpecialtyFilterBar({
    super.key,
    required this.specialties,
    required this.selectedSpecialtyId,
    required this.onSelected,
  });

  final List<Specialty> specialties;
  final int? selectedSpecialtyId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'Tất cả',
            selected: selectedSpecialtyId == null,
            onTap: () => onSelected(null),
          ),
          ...specialties.where((s) => s.id != null).map(
                (specialty) => _FilterChip(
                  label: specialty.name ?? 'Chuyên khoa',
                  selected: selectedSpecialtyId == specialty.id,
                  onTap: () => onSelected(specialty.id),
                ),
              ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}

/// Consultant list with search, filters, and real API integration.
class ConsultantListScreen extends StatefulWidget {
  const ConsultantListScreen({super.key});

  @override
  State<ConsultantListScreen> createState() => _ConsultantListScreenState();
}

class _ConsultantListScreenState extends State<ConsultantListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final presenter = context.read<ConsultantPresenter>();
      presenter.loadSpecialties();
      presenter.loadConsultants();
    });
  }

  Future<void> _pickFilterDate(ConsultantPresenter presenter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: presenter.filterDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Chọn ngày',
    );
    if (picked != null) {
      presenter.setFilterDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultantPresenter>(
      builder: (context, presenter, _) {
        return RefreshIndicator(
          onRefresh: presenter.refreshList,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: AppSpacing.screenPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SectionHeader(
                      title: 'Tư vấn viên',
                      subtitle: 'Tìm chuyên gia phù hợp với nhu cầu của bạn.',
                      responsive: false,
                    ),
                    AppSearchBar(
                      hint: 'Tìm theo tên, email, chuyên khoa...',
                      onChanged: presenter.setSearchQuery,
                      responsive: false,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SpecialtyFilterBar(
                      specialties: presenter.specialties,
                      selectedSpecialtyId: presenter.selectedSpecialtyId,
                      onSelected: presenter.setSpecialtyFilter,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FilterToolbar(
                      availableOnly: presenter.availableOnly,
                      filterDate: presenter.filterDate,
                      hasActiveFilters: presenter.hasActiveFilters,
                      onAvailableOnlyChanged: presenter.setAvailableOnly,
                      onPickDate: () => _pickFilterDate(presenter),
                      onClearFilters: presenter.clearFilters,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ]),
                ),
              ),
              _buildBodySliver(context, presenter),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBodySliver(BuildContext context, ConsultantPresenter presenter) {
    return switch (presenter.listStatus) {
      ConsultantViewStatus.loading || ConsultantViewStatus.idle => SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: LoadingWidget(
              message: 'Đang tải tư vấn viên...',
            ),
          ),
        ),
      ConsultantViewStatus.error => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.listErrorMessage ??
                  'Không thể tải danh sách tư vấn viên.',
              onRetry: presenter.loadConsultants,
            ),
          ),
        ),
      ConsultantViewStatus.empty => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: EmptyStateWidget(
              title: 'Không tìm thấy tư vấn viên',
              message: presenter.hasActiveFilters
                  ? 'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm.'
                  : 'Hiện chưa có tư vấn viên nào trong hệ thống.',
              icon: Icons.person_search_outlined,
              actionLabel: presenter.hasActiveFilters ? 'Xóa bộ lọc' : null,
              onAction:
                  presenter.hasActiveFilters ? presenter.clearFilters : null,
            ),
          ),
        ),
      ConsultantViewStatus.success => SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(top: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final consultant = presenter.consultants[index];
                return ConsultantCard(
                  consultant: consultant,
                  onTap: () => _openDetail(context, consultant.consultantId),
                );
              },
              childCount: presenter.consultants.length,
            ),
          ),
        ),
    };
  }

  void _openDetail(BuildContext context, int consultantId) {
    context.pushNamed(
      RouteNames.consultantDetail,
      pathParameters: {'id': consultantId.toString()},
    );
  }
}

class _FilterToolbar extends StatelessWidget {
  const _FilterToolbar({
    required this.availableOnly,
    required this.filterDate,
    required this.hasActiveFilters,
    required this.onAvailableOnlyChanged,
    required this.onPickDate,
    required this.onClearFilters,
  });

  final bool availableOnly;
  final DateTime filterDate;
  final bool hasActiveFilters;
  final ValueChanged<bool> onAvailableOnlyChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Chỉ hiện có lịch trống',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Switch.adaptive(
                value: availableOnly,
                activeTrackColor: AppColors.primaryLight,
                activeThumbColor: AppColors.primary,
                onChanged: onAvailableOnlyChanged,
              ),
            ],
          ),
        ),
        if (availableOnly) ...[
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(_formatDate(filterDate)),
          ),
        ],
        if (hasActiveFilters) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
              label: const Text('Xóa bộ lọc'),
            ),
          ),
        ],
      ],
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
