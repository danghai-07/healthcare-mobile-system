import 'api_exception.dart';

/// Normalized wrapper for ASP.NET API responses that follow the
/// `{ success, data, message }` envelope pattern.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      data: fromJsonT != null && rawData != null ? fromJsonT(rawData) : null,
    );
  }

  final bool success;
  final T? data;
  final String? message;

  bool get isSuccess => success;
  bool get hasData => data != null;
}

/// Parses a raw JSON body that may be either an envelope or a direct payload.
T parseApiBody<T>(
  dynamic body,
  T Function(Map<String, dynamic> json) fromJson, {
  bool expectEnvelope = true,
}) {
  if (body is! Map<String, dynamic>) {
    throw const ApiException(
      message: 'Phản hồi từ máy chủ không hợp lệ.',
      code: 'invalid_response',
    );
  }

  if (expectEnvelope && body.containsKey('success')) {
    final response = ApiResponse<Map<String, dynamic>>.fromJson(
      body,
      (value) => value as Map<String, dynamic>,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message ?? 'Yêu cầu không thành công.',
        code: 'api_failure',
      );
    }

    final data = response.data;
    if (data == null) {
      throw const ApiException(
        message: 'Dữ liệu trả về trống.',
        code: 'empty_data',
      );
    }

    return fromJson(data);
  }

  return fromJson(body);
}
