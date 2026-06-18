import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/auth_interceptor.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/unauthorized_notifier.dart';
import '../../features/appointment/data/repositories/appointment_repository_impl.dart';
import '../../features/appointment/data/services/appointment_api_service.dart';
import '../../features/appointment/domain/repositories/appointment_repository.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_api_service.dart';
import '../../features/auth/domain/entities/user_session.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/blog/data/repositories/blog_repository_impl.dart';
import '../../features/blog/data/services/blog_api_service.dart';
import '../../features/blog/domain/repositories/blog_repository.dart';
import '../../features/consultant/data/repositories/consultant_repository_impl.dart';
import '../../features/consultant/data/services/consultant_api_service.dart';
import '../../features/consultant/domain/repositories/consultant_repository.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/services/profile_api_service.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/service/data/repositories/service_repository_impl.dart';
import '../../features/service/data/services/service_api_service.dart';
import '../../features/service/domain/repositories/service_repository.dart';
import '../../routes/app_router.dart';
import '../../routes/auth_guard.dart';

/// Registers foundation and feature-layer dependencies.
class AppDependencyScope {
  AppDependencyScope({
    required AuthLocalDataSource authLocalDataSource,
  }) : _authLocalDataSource = authLocalDataSource;

  final AuthLocalDataSource _authLocalDataSource;

  List<SingleChildWidget> get providers => [
        Provider<AuthLocalDataSource>.value(value: _authLocalDataSource),
        Provider<TokenProvider>.value(value: _authLocalDataSource),
        Provider<UnauthorizedNotifier>(
          create: (_) => UnauthorizedNotifier(),
        ),
        ProxyProvider2<TokenProvider, UnauthorizedNotifier, DioClient>(
          update: (_, tokenProvider, unauthorizedNotifier, previous) =>
              previous ??
              DioClient(
                tokenProvider: tokenProvider,
                onUnauthorized: unauthorizedNotifier.notify,
              ),
        ),
        ProxyProvider<DioClient, AuthApiService>(
          update: (_, client, previous) =>
              previous ?? AuthApiService(client),
        ),
        ProxyProvider<DioClient, ConsultantApiService>(
          update: (_, client, previous) =>
              previous ?? ConsultantApiService(client),
        ),
        ProxyProvider<DioClient, AppointmentApiService>(
          update: (_, client, previous) =>
              previous ?? AppointmentApiService(client),
        ),
        ProxyProvider<DioClient, ServiceApiService>(
          update: (_, client, previous) =>
              previous ?? ServiceApiService(client),
        ),
        ProxyProvider<DioClient, BlogApiService>(
          update: (_, client, previous) => previous ?? BlogApiService(client),
        ),
        ProxyProvider<DioClient, ProfileApiService>(
          update: (_, client, previous) =>
              previous ?? ProfileApiService(client),
        ),
        ProxyProvider2<AuthApiService, AuthLocalDataSource, AuthRepository>(
          update: (_, api, local, previous) =>
              previous ?? AuthRepositoryImpl(
                apiService: api,
                localDataSource: local,
              ),
        ),
        ProxyProvider<ConsultantApiService, ConsultantRepository>(
          update: (_, api, previous) =>
              previous ?? ConsultantRepositoryImpl(api),
        ),
        ProxyProvider<AppointmentApiService, AppointmentRepository>(
          update: (_, api, previous) =>
              previous ?? AppointmentRepositoryImpl(api),
        ),
        ProxyProvider<ServiceApiService, ServiceRepository>(
          update: (_, api, previous) => previous ?? ServiceRepositoryImpl(api),
        ),
        ProxyProvider<BlogApiService, BlogRepository>(
          update: (_, api, previous) => previous ?? BlogRepositoryImpl(api),
        ),
        ProxyProvider<ProfileApiService, ProfileRepository>(
          update: (_, api, previous) =>
              previous ?? ProfileRepositoryImpl(api),
        ),
        ChangeNotifierProvider<SessionAuthStateReader>(
          create: (context) {
            final reader = SessionAuthStateReader(
              authRepository: context.read<AuthRepository>(),
            );
            context.read<UnauthorizedNotifier>().onUnauthorized = reader.refresh;
            return reader;
          },
        ),
        ProxyProvider<SessionAuthStateReader, AuthStateReader>(
          update: (_, reader, previous) => reader,
        ),
        ProxyProvider<SessionAuthStateReader, AppRouter>(
          update: (_, authStateReader, previous) =>
              previous ?? AppRouter(authStateReader: authStateReader),
        ),
      ];
}

/// Bridges [AuthRepository] session state to GoRouter guards.
class SessionAuthStateReader extends ChangeNotifier implements AuthStateReader {
  SessionAuthStateReader({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _loadSession();
  }

  final AuthRepository _authRepository;
  UserSession? _session;

  @override
  bool get isAuthenticated => _session?.isAuthenticated ?? false;

  @override
  Listenable get listenable => this;

  Future<void> refresh() => _loadSession();

  Future<void> _loadSession() async {
    _session = await _authRepository.getCurrentSession();
    notifyListeners();
  }
}
