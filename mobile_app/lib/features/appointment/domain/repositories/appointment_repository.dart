import '../entities/appointment.dart';
import '../entities/create_appointment_request.dart';

abstract interface class AppointmentRepository {
  Future<int> createAppointment(CreateAppointmentRequest request);
  Future<List<Appointment>> getAllAppointments();
  Future<AppointmentDetail> getAppointmentDetail(int id);
  Future<List<Appointment>> getAppointmentsByMember(int memberId);
  Future<List<Appointment>> getAppointmentsByConsultant(int consultantId);
  Future<void> updateStatus(int id, String status);
  Future<void> updateMeetLink(int id, String meetLink);
}
