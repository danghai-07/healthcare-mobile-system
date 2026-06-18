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

/// Login screen wired to [AuthPresenter] and Swagger `/api/login`.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.initialMessage,
  });

  final String? initialMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthPresenter>().reset();
      final message = widget.initialMessage;
      if (message != null && message.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthPresenter presenter) async {
    FocusScope.of(context).unfocus();
    presenter.clearMessages();

    final success = await presenter.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted || !success) {
      return;
    }

    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          body: LoadingOverlay(
            isLoading: presenter.isLoading,
            message: 'Đang đăng nhập...',
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const AuthFormHeader(
                      title: 'Chào mừng trở lại',
                      subtitle:
                          'Đăng nhập để đặt lịch tư vấn và theo dõi sức khỏe.',
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    if (presenter.errorMessage != null) ...[
                      AppErrorWidget(
                        message: presenter.errorMessage!,
                        title: 'Đăng nhập thất bại',
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
                      onChanged: (_) {
                        if (presenter.emailError != null) {
                          presenter.clearMessages();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hint: 'Nhập mật khẩu',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
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
                      onSubmitted: (_) => _submit(presenter),
                      onChanged: (_) {
                        if (presenter.passwordError != null) {
                          presenter.clearMessages();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: presenter.isLoading
                            ? null
                            : () => context.push(RoutePaths.forgotPassword),
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      label: 'Đăng nhập',
                      icon: Icons.arrow_forward_rounded,
                      isLoading: presenter.isLoading,
                      onPressed: presenter.isLoading
                          ? null
                          : () => _submit(presenter),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SecondaryButton(
                      label: 'Tạo tài khoản',
                      onPressed: presenter.isLoading
                          ? null
                          : () => context.push(RoutePaths.register),
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
