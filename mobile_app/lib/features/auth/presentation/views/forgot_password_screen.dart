import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../presenters/auth_presenter.dart';
import 'auth_form_header.dart';

enum _ForgotPasswordStep { email, reset }

/// Password recovery via OTP email and `POST /api/user/reset-password`.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _ForgotPasswordStep _step = _ForgotPasswordStep.email;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp(AuthPresenter presenter) async {
    FocusScope.of(context).unfocus();
    presenter.clearMessages();

    final success = await presenter.sendForgotPasswordOtp(
      email: _emailController.text,
    );

    if (!mounted || !success) {
      return;
    }

    setState(() => _step = _ForgotPasswordStep.reset);
  }

  Future<void> _resetPassword(AuthPresenter presenter) async {
    FocusScope.of(context).unfocus();
    presenter.clearMessages();

    final success = await presenter.resetPasswordWithOtp(
      email: _emailController.text,
      otpCode: _otpController.text,
      newPassword: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted || !success) {
      return;
    }

    context.go(
      '${RoutePaths.login}?message=${Uri.encodeComponent(presenter.successMessage ?? 'Đặt lại mật khẩu thành công.')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isLoading,
            message: _step == _ForgotPasswordStep.email
                ? 'Đang gửi OTP...'
                : 'Đang đặt lại mật khẩu...',
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  AuthFormHeader(
                    title: _step == _ForgotPasswordStep.email
                        ? 'Quên mật khẩu'
                        : 'Đặt lại mật khẩu',
                    subtitle: _step == _ForgotPasswordStep.email
                        ? 'Nhập email để nhận mã OTP khôi phục.'
                        : 'Nhập mã OTP và mật khẩu mới.',
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  if (presenter.errorMessage != null) ...[
                    AppErrorWidget(
                      message: presenter.errorMessage!,
                      compact: true,
                      responsive: false,
                      onRetry: () => _step == _ForgotPasswordStep.email
                          ? _sendOtp(presenter)
                          : _resetPassword(presenter),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (presenter.successMessage != null &&
                      _step == _ForgotPasswordStep.email) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        presenter.successMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'name@example.com',
                    keyboardType: TextInputType.emailAddress,
                    readOnly: _step == _ForgotPasswordStep.reset,
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    errorText: presenter.emailError,
                    onChanged: (_) => presenter.clearMessages(),
                  ),
                  if (_step == _ForgotPasswordStep.reset) ...[
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _otpController,
                      label: 'Mã OTP',
                      hint: '6 chữ số',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.pin_outlined),
                      errorText: presenter.otpError,
                      onChanged: (_) => presenter.clearMessages(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu mới',
                      hint: 'Ít nhất 6 ký tự',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        icon: Icon(
                          _obscurePassword
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
                      label: 'Xác nhận mật khẩu',
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
                      onSubmitted: (_) => _resetPassword(presenter),
                      onChanged: (_) => presenter.clearMessages(),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: _step == _ForgotPasswordStep.email
                        ? 'Gửi mã OTP'
                        : 'Đặt lại mật khẩu',
                    icon: _step == _ForgotPasswordStep.email
                        ? Icons.send_outlined
                        : Icons.lock_reset_rounded,
                    isLoading: presenter.isLoading,
                    onPressed: presenter.isLoading
                        ? null
                        : () => _step == _ForgotPasswordStep.email
                            ? _sendOtp(presenter)
                            : _resetPassword(presenter),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    label: 'Quay lại đăng nhập',
                    onPressed: presenter.isLoading
                        ? null
                        : () => context.go(RoutePaths.login),
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
