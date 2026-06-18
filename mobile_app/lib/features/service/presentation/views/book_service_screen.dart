import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../presenters/service_presenter.dart';
import '../presenters/service_view_status.dart';

/// Booking form for `POST /api/TestServiceRecord/book`.
class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({
    super.key,
    required this.serviceId,
  });

  final int serviceId;

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicePresenter>().initBooking(widget.serviceId);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDob(ServicePresenter presenter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: presenter.dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
    );
    if (picked != null) {
      presenter.setDateOfBirth(picked);
    }
  }

  Future<void> _pickTestDate(ServicePresenter presenter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: presenter.testDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Chọn ngày xét nghiệm',
    );
    if (picked != null) {
      presenter.setTestDate(picked);
    }
  }

  Future<void> _submit(ServicePresenter presenter) async {
    FocusScope.of(context).unfocus();
    final recordId = await presenter.bookService();
    if (!mounted || recordId == null) {
      return;
    }

    context.go(
      '${RoutePaths.bookingConfirm}?recordId=$recordId',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicePresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Đặt xét nghiệm',
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isBooking,
            message: 'Đang đặt lịch...',
            child: _buildBody(context, presenter),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ServicePresenter presenter) {
    return switch (presenter.bookingInitStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải...')),
      ServiceViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.bookingInitErrorMessage ??
                  'Không thể tải thông tin đặt lịch.',
              onRetry: () => presenter.initBooking(widget.serviceId),
            ),
          ),
        ),
      ServiceViewStatus.success => _buildForm(context, presenter),
      ServiceViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildForm(BuildContext context, ServicePresenter presenter) {
    final service = presenter.bookingService;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (service != null)
            AppCard(
              showShadow: true,
              child: Text(
                service.name ?? 'Dịch vụ xét nghiệm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(
            title: 'Thông tin bệnh nhân',
            responsive: false,
          ),
          AppTextField(
            controller: _fullNameController,
            label: 'Họ và tên',
            hint: 'Nguyễn Văn A',
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            errorText: presenter.fullNameError,
            onChanged: presenter.setFullName,
            responsive: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Giới tính',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: presenter.gender,
            decoration: InputDecoration(
              errorText: presenter.genderError,
              hintText: 'Chọn giới tính',
            ),
            items: const [
              DropdownMenuItem(value: 'Nam', child: Text('Nam')),
              DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
              DropdownMenuItem(value: 'Khác', child: Text('Khác')),
            ],
            onChanged: presenter.isBooking ? null : presenter.setGender,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            hint: '09xxxxxxxx',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            errorText: presenter.phoneError,
            onChanged: presenter.setPhoneNumber,
            responsive: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Ngày sinh',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed:
                presenter.isBooking ? null : () => _pickDob(presenter),
            icon: const Icon(Icons.cake_outlined, size: 18),
            label: Text(
              presenter.dateOfBirth != null
                  ? _formatDate(presenter.dateOfBirth!)
                  : 'Chọn ngày sinh',
            ),
          ),
          if (presenter.dobError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              presenter.dobError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(
            title: 'Lịch xét nghiệm',
            responsive: false,
          ),
          OutlinedButton.icon(
            onPressed:
                presenter.isBooking ? null : () => _pickTestDate(presenter),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(_formatDate(presenter.testDate)),
          ),
          if (presenter.testDateError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              presenter.testDateError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _ShiftSection(presenter: presenter),
          if (presenter.bookingErrorMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppErrorWidget(
              message: presenter.bookingErrorMessage!,
              title: 'Đặt lịch thất bại',
              compact: true,
              responsive: false,
              onRetry: () => _submit(presenter),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Xác nhận đặt xét nghiệm',
            icon: Icons.check_circle_outline_rounded,
            isLoading: presenter.isBooking,
            onPressed: presenter.isBooking ? null : () => _submit(presenter),
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

class _ShiftSection extends StatelessWidget {
  const _ShiftSection({required this.presenter});

  final ServicePresenter presenter;

  @override
  Widget build(BuildContext context) {
    return switch (presenter.shiftsStatus) {
      ServiceViewStatus.loading || ServiceViewStatus.idle =>
        const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: LoadingWidget.inline(),
          ),
        ),
      ServiceViewStatus.error => AppErrorWidget(
          message: presenter.shiftError ?? 'Không thể tải ca xét nghiệm.',
          compact: true,
          responsive: false,
          onRetry: presenter.loadWorkShifts,
        ),
      ServiceViewStatus.empty => EmptyStateWidget(
          title: 'Không còn ca trống',
          message: 'Vui lòng chọn ngày khác.',
          icon: Icons.event_busy_outlined,
          compact: true,
          responsive: false,
        ),
      ServiceViewStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ca xét nghiệm',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...presenter.workShifts.map((shift) {
              final selected = presenter.selectedShiftId == shift.shiftId;
              final enabled = shift.isAvailable && !presenter.isBooking;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: enabled
                      ? () => presenter.selectShift(shift.shiftId)
                      : null,
                  borderColor: selected ? AppColors.primary : AppColors.border,
                  backgroundColor:
                      selected ? AppColors.primaryLight : AppColors.surface,
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: enabled
                            ? AppColors.primary
                            : AppColors.textDisabled,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shift.displayLabel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (shift.status != null &&
                                shift.status!.isNotEmpty)
                              Text(
                                shift.status!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: shift.isAvailable
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (presenter.shiftError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                presenter.shiftError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
              ),
            ],
          ],
        ),
    };
  }
}
