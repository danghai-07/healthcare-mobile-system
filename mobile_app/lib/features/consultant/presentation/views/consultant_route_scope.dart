import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repositories/consultant_repository.dart';
import '../presenters/consultant_presenter.dart';

/// Provides a scoped [ConsultantPresenter] for consultant screens.
class ConsultantRouteScope extends StatelessWidget {
  const ConsultantRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsultantPresenter>(
      create: (context) => ConsultantPresenter(
        consultantRepository: context.read<ConsultantRepository>(),
      ),
      child: child,
    );
  }
}
