import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Maps low-level transport errors into [ApiException] for the data layer.
abstract final class ErrorMapper {
  static ApiException fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Kết nối quá thời gian chờ. Vui lòng thử lại.',
          code: 'timeout',
          statusCode: error.response?.statusCode,
          originalError: error,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Không thể kết nối đến máy chủ. Kiểm tra mạng của bạn.',
          code: 'connection_error',
          originalError: error,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Yêu cầu đã bị hủy.',
          code: 'cancelled',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        return _fromResponse(error);
      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Chứng chỉ bảo mật không hợp lệ.',
          code: 'bad_certificate',
          originalError: error,
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: 'Đã xảy ra lỗi không xác định.',
          code: 'unknown',
          originalError: error,
        );
    }
  }

  static ApiException _fromResponse(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final message = _extractMessage(response?.data) ??
        _defaultMessageForStatus(statusCode);

    return ApiException(
      message: message,
      statusCode: statusCode,
      code: 'http_$statusCode',
      originalError: error,
    );
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      final title = data['title'];
      if (title is String && title.trim().isNotEmpty) {
        return title;
      }
    }

    return null;
  }

  static String _defaultMessageForStatus(int? statusCode) {
    return switch (statusCode) {
      400 => 'Dữ liệu gửi lên không hợp lệ.',
      401 => 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
      403 => 'Bạn không có quyền thực hiện thao tác này.',
      404 => 'Không tìm thấy tài nguyên yêu cầu.',
      409 => 'Dữ liệu đã tồn tại hoặc xung đột.',
      422 => 'Dữ liệu không thể xử lý.',
      500 => 'Lỗi máy chủ. Vui lòng thử lại sau.',
      _ => 'Yêu cầu không thành công.',
    };
  }
}
