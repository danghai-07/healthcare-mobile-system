import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import 'auth_interceptor.dart';
import 'error_mapper.dart';
import 'logging_interceptor.dart';

/// Centralized Dio instance configured for the Healthcare API.
class DioClient {
  DioClient({
    String? baseUrl,
    TokenProvider? tokenProvider,
    Future<void> Function()? onUnauthorized,
    List<Interceptor>? extraInterceptors,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? AppConstants.defaultBaseUrl,
            connectTimeout: AppConstants.connectTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            sendTimeout: AppConstants.sendTimeout,
            contentType: AppConstants.jsonContentType,
            headers: {
              'Accept': AppConstants.acceptJson,
            },
            responseType: ResponseType.json,
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        ) {
    if (tokenProvider != null) {
      _dio.interceptors.add(
        AuthInterceptor(
          tokenProvider: tokenProvider,
          onUnauthorized: onUnauthorized,
        ),
      );
    }

    _dio.interceptors.add(LoggingInterceptor());

    if (extraInterceptors != null) {
      _dio.interceptors.addAll(extraInterceptors);
    }
  }

  final Dio _dio;

  Dio get instance => _dio;

  String get baseUrl => _dio.options.baseUrl;

  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _safeRequest(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _safeRequest(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _safeRequest(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _safeRequest(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _safeRequest(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw ErrorMapper.fromDioException(error);
    }
  }
}
