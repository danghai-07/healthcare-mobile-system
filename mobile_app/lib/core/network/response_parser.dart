import 'api_exception.dart';
import 'api_response.dart';
import '../utils/json_read.dart';

/// Parses heterogeneous ASP.NET API response bodies.
abstract final class ResponseParser {
  static T parseObject<T>(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJson, {
    bool expectEnvelope = true,
  }) {
    if (body is Map<String, dynamic>) {
      if (expectEnvelope && body.containsKey('success')) {
        return parseApiBody(body, fromJson, expectEnvelope: true);
      }
      return fromJson(body);
    }

    throw const ApiException(
      message: 'Phản hồi từ máy chủ không hợp lệ.',
      code: 'invalid_response',
    );
  }

  static List<T> parseList<T>(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJson, {
    bool expectEnvelope = false,
  }) {
    if (body is List) {
      return JsonRead.mapList(body).map(fromJson).toList();
    }

    if (body is Map<String, dynamic>) {
      if (body.containsKey('success')) {
        final response = ApiResponse<dynamic>.fromJson(body, (value) => value);
        if (!response.success) {
          throw ApiException(
            message: response.message ?? 'Yêu cầu không thành công.',
            code: 'api_failure',
          );
        }
        return JsonRead.mapList(response.data).map(fromJson).toList();
      }

      if (body.containsKey('data')) {
        return JsonRead.mapList(body['data']).map(fromJson).toList();
      }
    }

    throw const ApiException(
      message: 'Phản hồi danh sách không hợp lệ.',
      code: 'invalid_list_response',
    );
  }

  static List<String> parseStringList(dynamic body) {
    if (body is List) {
      return body.map((e) => e.toString()).toList();
    }

    if (body is Map<String, dynamic>) {
      if (body.containsKey('success')) {
        final response = ApiResponse<dynamic>.fromJson(body, (value) => value);
        if (!response.success) {
          throw ApiException(
            message: response.message ?? 'Yêu cầu không thành công.',
            code: 'api_failure',
          );
        }
        final data = response.data;
        if (data is List) {
          return data.map((e) => e.toString()).toList();
        }
      }

      final data = body['data'];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
    }

    throw const ApiException(
      message: 'Phản hồi danh sách không hợp lệ.',
      code: 'invalid_string_list',
    );
  }

  static int parseIntData(dynamic body) {
    if (body is int) {
      return body;
    }
    if (body is num) {
      return body.toInt();
    }

    if (body is Map<String, dynamic>) {
      if (body.containsKey('success')) {
        final response = ApiResponse<dynamic>.fromJson(body, (value) => value);
        if (!response.success) {
          throw ApiException(
            message: response.message ?? 'Yêu cầu không thành công.',
            code: 'api_failure',
          );
        }
        final data = response.data;
        if (data is int) {
          return data;
        }
        if (data is num) {
          return data.toInt();
        }
      }

      final data = body['data'];
      if (data is int) {
        return data;
      }
      if (data is num) {
        return data.toInt();
      }
    }

    throw const ApiException(
      message: 'Phản hồi số nguyên không hợp lệ.',
      code: 'invalid_int_response',
    );
  }
}
