import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/di/app_dependency_scope.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../presenters/profile_presenter.dart';

/// Provides a scoped [ProfilePresenter] for profile screens.
class ProfileRouteScope extends StatelessWidget {
  const ProfileRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfilePresenter>(
      create: (context) => ProfilePresenter(
        profileRepository: context.read<ProfileRepository>(),
        authRepository: context.read<AuthRepository>(),
        sessionReader: context.read<SessionAuthStateReader>(),
      ),
      child: child,
    );
  }
}
