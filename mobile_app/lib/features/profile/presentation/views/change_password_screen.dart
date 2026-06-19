import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../presenters/profile_presenter.dart';

/// Change password for signed-in members via `POST /api/user/change-password/{userId}`.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(ProfilePresenter presenter) async {
    FocusScope.of(context).unfocus();
    presenter.clearMessages();

    final success = await presenter.changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          presenter.successMessage ?? 'Đã đổi mật khẩu thành công.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Đổi mật khẩu',
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isChangingPassword,
            message: 'Đang cập nhật...',
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(
                    title: 'Bảo mật tài khoản',
                    subtitle:
                        'Nhập mật khẩu hiện tại và mật khẩu mới của bạn.',
                    accentTitle: true,
                    responsive: false,
                  ),
                  if (presenter.errorMessage != null) ...[
                    AppErrorWidget(
                      message: presenter.errorMessage!,
                      compact: true,
                      responsive: false,
                      onRetry: () => _submit(presenter),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  AppTextField(
                    controller: _oldPasswordController,
                    label: 'Mật khẩu hiện tại',
                    hint: 'Nhập mật khẩu hiện tại',
                    obscureText: _obscureOld,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obscureOld = !_obscureOld);
                      },
                      icon: Icon(
                        _obscureOld
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    errorText: presenter.oldPasswordError,
                    onChanged: (_) => presenter.clearMessages(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _newPasswordController,
                    label: 'Mật khẩu mới',
                    hint: 'Ít nhất 6 ký tự',
                    obscureText: _obscureNew,
                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obscureNew = !_obscureNew);
                      },
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    errorText: presenter.newPasswordError,
                    onChanged: (_) => presenter.clearMessages(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu mới',
                    hint: 'Nhập lại mật khẩu mới',
                    obscureText: _obscureConfirm,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    errorText: presenter.confirmPasswordError,
                    onSubmitted: (_) => _submit(presenter),
                    onChanged: (_) => presenter.clearMessages(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: 'Cập nhật mật khẩu',
                    icon: Icons.check_rounded,
                    isLoading: presenter.isChangingPassword,
                    onPressed: presenter.isChangingPassword
                        ? null
                        : () => _submit(presenter),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
