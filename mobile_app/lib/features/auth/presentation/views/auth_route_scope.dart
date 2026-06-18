import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../app/di/app_dependency_scope.dart';
import '../../domain/repositories/auth_repository.dart';
import '../presenters/auth_presenter.dart';

/// Provides a scoped [AuthPresenter] for auth screens.
class AuthRouteScope extends StatelessWidget {
  const AuthRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthPresenter>(
      create: (context) => AuthPresenter(
        authRepository: context.read<AuthRepository>(),
        sessionReader: context.read<SessionAuthStateReader>(),
      ),
      child: child,
    );
  }
}
