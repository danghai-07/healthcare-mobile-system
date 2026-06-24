import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/profile_hero.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/profile_quick_actions.dart';
import '../presenters/profile_presenter.dart';
import '../presenters/profile_view_status.dart';

/// Member profile screen powered by `GET /api/user/get/{userId}`.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfilePresenter>().loadProfile();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfilePresenter presenter) {
    if (_fullNameController.text != presenter.fullName) {
      _fullNameController.text = presenter.fullName;
    }
    if (_emailController.text != presenter.email) {
      _emailController.text = presenter.email;
    }
    if (_phoneController.text != presenter.phoneNumber) {
      _phoneController.text = presenter.phoneNumber;
    }
    if (_addressController.text != presenter.address) {
      _addressController.text = presenter.address;
    }
  }

  Future<void> _pickDateOfBirth(ProfilePresenter presenter) async {
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

  Future<void> _save(ProfilePresenter presenter) async {
    FocusScope.of(context).unfocus();
    final success = await presenter.saveProfile();
    if (!mounted || !success) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(presenter.successMessage ?? 'Đã cập nhật hồ sơ.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _logout(ProfilePresenter presenter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await presenter.logout();
    if (mounted) {
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePresenter>(
      builder: (context, presenter, _) {
        _syncControllers(presenter);

        return AppScaffold(
          body: LoadingOverlay(
            isLoading: presenter.isSaving,
            message: 'Đang lưu...',
            child: _buildBody(context, presenter),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfilePresenter presenter) {
    return switch (presenter.status) {
      ProfileViewStatus.loading || ProfileViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải hồ sơ...')),
      ProfileViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.errorMessage ??
                  'Không thể tải hồ sơ cá nhân.',
              onRetry: presenter.loadProfile,
            ),
          ),
        ),
      ProfileViewStatus.success => _buildContent(context, presenter),
    };
  }

  Widget _buildContent(BuildContext context, ProfilePresenter presenter) {
    final profile = presenter.profile;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHero(
            name: profile?.fullName ?? 'Thành viên',
            email: profile?.email,
            gender: profile?.gender,
            avatarUrl: profile?.avatar,
          ),
          Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileQuickActions(),
                const SizedBox(height: AppSpacing.lg),
                if (profile?.roleId != null) ...[
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    backgroundColor: AppColors.primaryMuted,
                    borderColor: AppColors.primaryLight,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Vai trò: ${profile!.roleId}',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                const SectionHeader(
                  title: 'Thông tin cá nhân',
                  subtitle: 'Cập nhật thông tin liên hệ của bạn.',
                  accentTitle: true,
                  responsive: false,
                ),
                AppCard(
                  showShadow: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
          AppTextField(
            controller: _fullNameController,
            label: 'Họ và tên',
            hint: 'Nguyễn Văn A',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            onChanged: presenter.setFullName,
            responsive: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'email@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            onChanged: presenter.setEmail,
            responsive: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            hint: '09xxxxxxxx',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            onChanged: presenter.setPhoneNumber,
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
            decoration: const InputDecoration(
              hintText: 'Chọn giới tính',
            ),
            items: const [
              DropdownMenuItem(value: 'Nam', child: Text('Nam')),
              DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
              DropdownMenuItem(value: 'Khác', child: Text('Khác')),
            ],
            onChanged: presenter.isSaving ? null : presenter.setGender,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Ngày sinh',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed:
                presenter.isSaving ? null : () => _pickDateOfBirth(presenter),
            icon: const Icon(Icons.cake_outlined, size: 18),
            label: Text(
              presenter.dateOfBirth != null
                  ? _formatDate(presenter.dateOfBirth!)
                  : 'Chọn ngày sinh',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _addressController,
            label: 'Địa chỉ',
            hint: 'Quận, TP.HCM',
            prefixIcon: const Icon(Icons.location_on_outlined),
            onChanged: presenter.setAddress,
            responsive: false,
          ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  backgroundColor: AppColors.primaryMuted,
                  borderColor: AppColors.primaryLight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Thông tin cá nhân được bảo mật và chỉ dùng '
                          'cho mục đích chăm sóc sức khỏe.',
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
          if (presenter.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppErrorWidget(
              message: presenter.errorMessage!,
              compact: true,
              responsive: false,
              onRetry: () => _save(presenter),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Lưu thay đổi',
            icon: Icons.save_outlined,
            isLoading: presenter.isSaving,
            onPressed: presenter.isSaving ? null : () => _save(presenter),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Đổi mật khẩu',
            icon: Icons.lock_outline_rounded,
            onPressed: presenter.isSaving
                ? null
                : () => context.push(RoutePaths.changePassword),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Đăng xuất',
            icon: Icons.logout_rounded,
            onPressed:
                presenter.isSaving ? null : () => _logout(presenter),
          ),
          const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
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
