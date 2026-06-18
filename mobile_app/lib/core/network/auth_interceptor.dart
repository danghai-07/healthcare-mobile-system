import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Supplies access and refresh tokens for authenticated API calls.
///
/// Feature modules implement this contract (e.g. via SharedPreferences).
abstract interface class TokenProvider {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearSession();
}

/// Attaches bearer tokens and coordinates session cleanup on 401 responses.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenProvider,
    this.onUnauthorized,
    this.skipAuthForPaths = const {
      '/api/login',
      '/api/register',
      '/api/google-login',
      '/api/otp/sendOtpByUserId',
      '/api/otp/sendOtpByEmail',
      '/api/otp/verify',
      '/api/user/reset-password',
    },
  });

  final TokenProvider tokenProvider;
  final Future<void> Function()? onUnauthorized;
  final Set<String> skipAuthForPaths;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldAttachToken(options.path)) {
      final token = await tokenProvider.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] =
            '${AppConstants.bearerScheme} $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && _shouldAttachToken(err.requestOptions.path)) {
      await tokenProvider.clearSession();
      await onUnauthorized?.call();
    }

    handler.next(err);
  }

  bool _shouldAttachToken(String path) {
    for (final skipPath in skipAuthForPaths) {
      if (path.startsWith(skipPath)) {
        return false;
      }
    }
    return true;
  }
}
