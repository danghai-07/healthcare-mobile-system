import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/doctor_avatar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../presenters/appointment_presenter.dart';
import '../presenters/appointment_view_status.dart';

/// Slot selection and appointment creation screen.
class SlotSelectionScreen extends StatefulWidget {
  const SlotSelectionScreen({
    super.key,
    required this.consultantId,
  });

  final int consultantId;

  @override
  State<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends State<SlotSelectionScreen> {
  late final TextEditingController _symptomsController;

  @override
  void initState() {
    super.initState();
    _symptomsController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AppointmentPresenter>()
          .initSlotSelection(widget.consultantId);
    });
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(AppointmentPresenter presenter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: presenter.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Chọn ngày tư vấn',
    );
    if (picked != null) {
      presenter.setSelectedDate(picked);
    }
  }

  Future<void> _submit(AppointmentPresenter presenter) async {
    FocusScope.of(context).unfocus();
    final appointmentId = await presenter.createAppointment();
    if (!mounted || appointmentId == null) {
      return;
    }

    context.go(
      '${RoutePaths.bookingConfirm}?appointmentId=$appointmentId',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chọn khung giờ',
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isCreating,
            message: 'Đang đặt lịch...',
            child: _buildBody(context, presenter),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppointmentPresenter presenter) {
    return switch (presenter.bookingInitStatus) {
      AppointmentViewStatus.loading || AppointmentViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải thông tin...')),
      AppointmentViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.bookingInitErrorMessage ??
                  'Không thể tải thông tin đặt lịch.',
              onRetry: () =>
                  presenter.initSlotSelection(widget.consultantId),
            ),
          ),
        ),
      AppointmentViewStatus.success => _buildForm(context, presenter),
      AppointmentViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildForm(BuildContext context, AppointmentPresenter presenter) {
    final consultant = presenter.bookingConsultant;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (consultant != null) ...[
            AppCard(
              showShadow: true,
              child: Row(
                children: [
                  DoctorAvatar(
                    avatarUrl: consultant.avatar,
                    gender: consultant.gender,
                    name: consultant.fullName,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultant.fullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          consultant.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
          const SectionHeader(
            title: 'Chọn ngày',
            accentTitle: true,
            responsive: false,
          ),
          OutlinedButton.icon(
            onPressed: presenter.isCreating ? null : () => _pickDate(presenter),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(_formatDate(presenter.selectedDate)),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(
            title: 'Khung giờ trống',
            subtitle: 'Mỗi buổi tư vấn kéo dài 30 phút.',
            accentTitle: true,
            responsive: false,
          ),
          _SlotGrid(presenter: presenter),
          const SizedBox(height: AppSpacing.xxl),
          if (presenter.consultationServices.length > 1) ...[
            Text('Dịch vụ', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<int>(
              initialValue: presenter.selectedServiceId,
              decoration: const InputDecoration(
                hintText: 'Chọn dịch vụ tư vấn',
              ),
              items: presenter.consultationServices
                  .map(
                    (service) => DropdownMenuItem(
                      value: service.serviceId,
                      child: Text(
                        service.name ?? 'Dịch vụ #${service.serviceId}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: presenter.isCreating
                  ? null
                  : presenter.setSelectedServiceId,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          AppTextField(
            controller: _symptomsController,
            label: 'Triệu chứng / ghi chú',
            hint: 'Mô tả ngắn về tình trạng sức khỏe (tuỳ chọn)',
            maxLines: 3,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.notes_outlined),
            onChanged: presenter.setSymptoms,
            responsive: false,
          ),
          if (presenter.createErrorMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppErrorWidget(
              message: presenter.createErrorMessage!,
              title: 'Đặt lịch thất bại',
              compact: true,
              responsive: false,
              onRetry: () => _submit(presenter),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Xác nhận đặt lịch',
            icon: Icons.check_circle_outline_rounded,
            isLoading: presenter.isCreating,
            onPressed: presenter.selectedSlot == null || presenter.isCreating
                ? null
                : () => _submit(presenter),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.presenter});

  final AppointmentPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return switch (presenter.slotsStatus) {
      AppointmentViewStatus.loading || AppointmentViewStatus.idle =>
        const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: LoadingWidget.inline(),
          ),
        ),
      AppointmentViewStatus.error => AppErrorWidget(
          message: presenter.slotsErrorMessage ?? 'Không thể tải khung giờ.',
          compact: true,
          responsive: false,
          onRetry: presenter.loadAvailableSlots,
        ),
      AppointmentViewStatus.empty => EmptyStateWidget(
          title: 'Không còn lịch trống',
          message: 'Vui lòng chọn ngày khác.',
          icon: Icons.event_busy_outlined,
          compact: true,
          responsive: false,
        ),
      AppointmentViewStatus.success => Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: presenter.availableSlots.map((slot) {
            final selected = presenter.selectedSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: selected,
              onSelected: presenter.isCreating
                  ? null
                  : (_) => presenter.selectSlot(slot),
              selectedColor: AppColors.primaryLight,
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                  ),
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
    };
  }
}
