import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import 'di/app_dependency_scope.dart';
import '../routes/app_router.dart';

/// Root widget wiring theme, dependency injection, and navigation.
class HealthcareApp extends StatelessWidget {
  const HealthcareApp({
    super.key,
    required this.dependencyScope,
  });

  final AppDependencyScope dependencyScope;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: dependencyScope.providers,
      child: Builder(
        builder: (context) {
          final appRouter = context.read<AppRouter>();
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}

/// Bootstraps async dependencies before running the app.
Future<HealthcareApp> bootstrapHealthcareApp() async {
  final authPreferences = await SharedPrefsAuthPreferences.create();
  final authLocalDataSource = AuthLocalDataSource(authPreferences);
  final dependencyScope = AppDependencyScope(
    authLocalDataSource: authLocalDataSource,
  );

  return HealthcareApp(dependencyScope: dependencyScope);
}
