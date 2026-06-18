import '../../domain/entities/appointment.dart';
import '../dtos/appointment_detail_dto.dart';
import '../dtos/appointment_list_item_dto.dart';

class AppointmentModel {
  const AppointmentModel._();

  static Appointment fromListItemDto(AppointmentListItemDto dto) => Appointment(
        appointmentId: dto.appointmentId,
        memberId: dto.memberId,
        memberName: dto.memberName,
        consultantId: dto.consultantId,
        consultantName: dto.consultantName,
        startTime: dto.startTime,
        endTime: dto.endTime,
        meetLink: dto.meetLink,
        status: dto.status,
        symptoms: dto.symptoms,
      );

  static AppointmentDetail fromDetailDto(AppointmentDetailDto dto) =>
      AppointmentDetail(
        appointmentId: dto.appointmentId,
        memberId: dto.memberId,
        memberName: dto.memberName,
        consultantId: dto.consultantId,
        consultantName: dto.consultantName,
        serviceId: dto.serviceId,
        serviceName: dto.serviceName,
        startTime: dto.startTime,
        endTime: dto.endTime,
        meetLink: dto.meetLink,
        status: dto.status,
        symptoms: dto.symptoms,
      );
}
