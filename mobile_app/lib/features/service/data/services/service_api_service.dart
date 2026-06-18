import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/book_test_service_record_dto.dart';
import '../dtos/service_dto.dart';
import '../dtos/test_service_record_dto.dart';
import '../dtos/work_shift_dto.dart';

class ServiceApiService {
  ServiceApiService(this._client);

  final DioClient _client;

  Future<List<ServiceDto>> getAllServices() async {
    final response = await _client.get<dynamic>(ApiEndpoints.services);
    return ResponseParser.parseList(
      response.data,
      ServiceDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<ServiceDto> getServiceById(int serviceId) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.services}/$serviceId',
    );
    return ResponseParser.parseObject(
      response.data,
      ServiceDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<int> bookTestService(BookTestServiceRecordDto dto) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.testServiceRecordBook,
      data: dto.toJson(),
    );

    final body = response.data;
    if (body is Map<String, dynamic>) {
      return BookTestServiceResponseDto.fromJson(body).testServiceRecordId ?? 0;
    }

    return 0;
  }

  Future<List<TestServiceRecordDto>> getRecordsByMember(int memberId) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.testServiceRecordByMember}/$memberId',
    );
    return ResponseParser.parseList(
      response.data,
      TestServiceRecordDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<TestServiceRecordDto> getRecordDetail(
    int testServiceRecordId,
    int memberId,
  ) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.testServiceRecordDetail}/$testServiceRecordId/$memberId',
    );
    return ResponseParser.parseObject(
      response.data,
      TestServiceRecordDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<void> cancelRecord(int testServiceRecordId, int userId) async {
    await _client.put<void>(
      ApiEndpoints.testServiceRecordCancel,
      queryParameters: {
        'testServiceRecordId': testServiceRecordId,
        'userId': userId,
      },
    );
  }

  Future<List<WorkShiftDto>> getWorkShifts(DateTime date) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.testServiceRecordWorkShifts,
      queryParameters: {'date': _formatDate(date)},
    );

    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(WorkShiftDto.fromJson)
          .toList();
    }
    return const [];
  }

  Future<List<dynamic>> getAvailableStaff(DateTime date) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.testServiceRecordAvailableStaff,
      queryParameters: {'date': _formatDate(date)},
    );
    return response.data as List<dynamic>? ?? const [];
  }

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
