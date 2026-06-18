import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/consultant_detail_dto.dart';
import '../dtos/consultant_with_specialty_dto.dart';
import '../dtos/specialty_dto.dart';

class ConsultantApiService {
  ConsultantApiService(this._client);

  final DioClient _client;

  Future<List<ConsultantWithSpecialtyDto>> getAllConsultants() async {
    final response = await _client.get<dynamic>(ApiEndpoints.consultants);
    return ResponseParser.parseList(
      response.data,
      ConsultantWithSpecialtyDto.fromJson,
    );
  }

  Future<List<ConsultantWithSpecialtyDto>> getAvailableConsultants(
    DateTime date,
  ) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.consultantsAvailable,
      queryParameters: {'date': date.toIso8601String()},
    );
    return ResponseParser.parseList(
      response.data,
      ConsultantWithSpecialtyDto.fromJson,
    );
  }

  Future<ConsultantDetailDto> getConsultantDetail(int id) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.consultantDetail}/$id',
    );
    return ResponseParser.parseObject(
      response.data,
      ConsultantDetailDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<List<String>> getAvailableSlots(int consultantId, DateTime date) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.consultantAvailableSlots}/$consultantId/available-slots',
      queryParameters: {'date': date.toIso8601String()},
    );
    return ResponseParser.parseStringList(response.data);
  }

  Future<List<SpecialtyDto>> getAllSpecialties() async {
    final response = await _client.get<dynamic>(ApiEndpoints.specialtyGetAll);
    return ResponseParser.parseList(
      response.data,
      SpecialtyDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<SpecialtyDto> getSpecialtyById(int id) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.specialtyGetById}/$id',
    );
    return ResponseParser.parseObject(
      response.data,
      SpecialtyDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<List<SpecialtyDto>> getSpecialtiesByUserId(int userId) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.specialtyGetByUserId}/$userId',
    );
    return ResponseParser.parseList(
      response.data,
      SpecialtyDto.fromJson,
      expectEnvelope: false,
    );
  }
}
