import '../../domain/entities/create_appointment_request.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../dtos/appointment_create_dto.dart';
import '../models/appointment_model.dart';
import '../services/appointment_api_service.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  AppointmentRepositoryImpl(this._apiService);

  final AppointmentApiService _apiService;

  @override
  Future<int> createAppointment(CreateAppointmentRequest request) {
    final dto = AppointmentCreateDto(
      memberId: request.memberId,
      serviceId: request.serviceId,
      consultantId: request.consultantId,
      startTime: request.startTime,
      endTime: request.endTime,
      meetLink: request.meetLink,
      symptoms: request.symptoms,
    );
    return _apiService.createAppointment(dto);
  }

  @override
  Future<List<Appointment>> getAllAppointments() async {
    final dtos = await _apiService.getAllAppointments();
    return dtos.map(AppointmentModel.fromListItemDto).toList();
  }

  @override
  Future<AppointmentDetail> getAppointmentDetail(int id) async {
    final dto = await _apiService.getAppointmentDetail(id);
    return AppointmentModel.fromDetailDto(dto);
  }

  @override
  Future<List<Appointment>> getAppointmentsByMember(int memberId) async {
    final dtos = await _apiService.getAppointmentsByMember(memberId);
    return dtos.map(AppointmentModel.fromListItemDto).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByConsultant(int consultantId) async {
    final dtos = await _apiService.getAppointmentsByConsultant(consultantId);
    return dtos.map(AppointmentModel.fromListItemDto).toList();
  }

  @override
  Future<void> updateStatus(int id, String status) =>
      _apiService.updateStatus(id, status);

  @override
  Future<void> updateMeetLink(int id, String meetLink) =>
      _apiService.updateMeetLink(id, meetLink);
}
