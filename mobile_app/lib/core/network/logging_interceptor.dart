import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs HTTP requests and responses in debug builds only.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '--> ${options.method} ${options.uri}\n'
        'Headers: ${options.headers}\n'
        'Body: ${options.data}',
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '<-- ${response.statusCode} ${response.requestOptions.uri}\n'
        'Body: ${response.data}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'xxx ${err.response?.statusCode} ${err.requestOptions.uri}\n'
        'Message: ${err.message}\n'
        'Body: ${err.response?.data}',
      );
    }
    super.onError(err, handler);
  }
}
