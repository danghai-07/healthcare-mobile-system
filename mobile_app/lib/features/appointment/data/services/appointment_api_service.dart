import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/appointment_create_dto.dart';
import '../dtos/appointment_detail_dto.dart';
import '../dtos/appointment_list_item_dto.dart';

class AppointmentApiService {
  AppointmentApiService(this._client);

  final DioClient _client;

  Future<int> createAppointment(AppointmentCreateDto dto) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.appointmentCreate,
      data: dto.toJson(),
    );
    return ResponseParser.parseIntData(response.data);
  }

  Future<List<AppointmentListItemDto>> getAllAppointments() async {
    final response = await _client.get<dynamic>(ApiEndpoints.appointmentList);
    return ResponseParser.parseList(
      response.data,
      AppointmentListItemDto.fromJson,
      expectEnvelope: true,
    );
  }

  Future<AppointmentDetailDto> getAppointmentDetail(int id) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.appointmentDetail}/$id',
    );
    return ResponseParser.parseObject(
      response.data,
      AppointmentDetailDto.fromJson,
      expectEnvelope: true,
    );
  }

  Future<List<AppointmentListItemDto>> getAppointmentsByMember(
    int memberId,
  ) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.appointmentByMember}/$memberId',
    );
    return ResponseParser.parseList(
      response.data,
      AppointmentListItemDto.fromJson,
      expectEnvelope: true,
    );
  }

  Future<List<AppointmentListItemDto>> getAppointmentsByConsultant(
    int consultantId,
  ) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.appointmentByConsultant}/$consultantId',
    );
    return ResponseParser.parseList(
      response.data,
      AppointmentListItemDto.fromJson,
      expectEnvelope: true,
    );
  }

  Future<void> updateStatus(int id, String status) async {
    await _client.patch<void>(
      '${ApiEndpoints.appointmentUpdateStatus}/$id',
      data: status,
    );
  }

  Future<void> updateMeetLink(int id, String meetLink) async {
    await _client.patch<void>(
      '${ApiEndpoints.appointmentUpdateMeetLink}/$id',
      data: meetLink,
    );
  }
}
