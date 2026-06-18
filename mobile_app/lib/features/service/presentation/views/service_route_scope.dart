import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/service_repository.dart';
import '../presenters/service_presenter.dart';

/// Provides a scoped [ServicePresenter] for medical test screens.
class ServiceRouteScope extends StatelessWidget {
  const ServiceRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ServicePresenter>(
      create: (context) => ServicePresenter(
        serviceRepository: context.read<ServiceRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: child,
    );
  }
}
