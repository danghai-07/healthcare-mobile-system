import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../consultant/domain/repositories/consultant_repository.dart';
import '../../../service/domain/repositories/service_repository.dart';
import '../../../service/presentation/presenters/service_presenter.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../presenters/appointment_presenter.dart';

/// Provides scoped presenters for appointment and test-record screens.
class AppointmentRouteScope extends StatelessWidget {
  const AppointmentRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppointmentPresenter>(
          create: (context) => AppointmentPresenter(
            appointmentRepository: context.read<AppointmentRepository>(),
            consultantRepository: context.read<ConsultantRepository>(),
            serviceRepository: context.read<ServiceRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<ServicePresenter>(
          create: (context) => ServicePresenter(
            serviceRepository: context.read<ServiceRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
