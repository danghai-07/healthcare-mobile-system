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

/// Registration screen wired to [AuthPresenter] and Swagger `/api/register`.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthPresenter>().reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthPresenter presenter) async {
    FocusScope.of(context).unfocus();
    presenter.clearMessages();

    final success = await presenter.register(
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted || !success) {
      return;
    }

    final message = presenter.successMessage;
    if (message != null) {
      context.go(
        '${RoutePaths.login}?message=${Uri.encodeComponent(message)}',
      );
      return;
    }

    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Đăng ký',
          showBackButton: true,
          body: LoadingOverlay(
            isLoading: presenter.isLoading,
            message: 'Đang tạo tài khoản...',
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthFormHeader(
                      title: 'Tạo tài khoản',
                      subtitle:
                          'Bắt đầu hành trình chăm sóc sức khỏe cùng CareWell.',
                      showLogo: false,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    if (presenter.errorMessage != null) ...[
                      AppErrorWidget(
                        message: presenter.errorMessage!,
                        title: 'Đăng ký thất bại',
                        compact: true,
                        responsive: false,
                        onRetry: () => _submit(presenter),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'name@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                      errorText: presenter.emailError,
                      onChanged: (_) => presenter.clearMessages(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      hint: '09xxxxxxxx',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      prefixIcon: const Icon(Icons.phone_outlined),
                      errorText: presenter.phoneError,
                      onChanged: (_) => presenter.clearMessages(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hint: 'Ít nhất 6 ký tự',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
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
                      errorText: presenter.passwordError,
                      onChanged: (_) => presenter.clearMessages(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu',
                      hint: 'Nhập lại mật khẩu',
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
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
                      label: 'Đăng ký',
                      icon: Icons.person_add_outlined,
                      isLoading: presenter.isLoading,
                      onPressed: presenter.isLoading
                          ? null
                          : () => _submit(presenter),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SecondaryButton(
                      label: 'Đã có tài khoản? Đăng nhập',
                      onPressed: presenter.isLoading
                          ? null
                          : () => context.go(RoutePaths.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
