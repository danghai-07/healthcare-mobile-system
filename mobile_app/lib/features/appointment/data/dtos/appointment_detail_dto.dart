import '../../../../core/utils/json_read.dart';

class AppointmentDetailDto {
  const AppointmentDetailDto({
    required this.appointmentId,
    required this.memberId,
    required this.memberName,
    required this.consultantId,
    required this.consultantName,
    required this.serviceId,
    required this.serviceName,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.meetLink,
    this.symptoms,
  });

  final int appointmentId;
  final int memberId;
  final String memberName;
  final int consultantId;
  final String consultantName;
  final int serviceId;
  final String serviceName;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetLink;
  final String status;
  final String? symptoms;

  factory AppointmentDetailDto.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailDto(
        appointmentId: JsonRead.intValue(json, 'appointmentId') ?? 0,
        memberId: JsonRead.intValue(json, 'memberId') ?? 0,
        memberName: JsonRead.string(json, 'memberName') ?? '',
        consultantId: JsonRead.intValue(json, 'consultantId') ?? 0,
        consultantName: JsonRead.string(json, 'consultantName') ?? '',
        serviceId: JsonRead.intValue(json, 'serviceId') ?? 0,
        serviceName: JsonRead.string(json, 'serviceName') ?? '',
        startTime: JsonRead.dateTime(json, 'startTime') ?? DateTime.now(),
        endTime: JsonRead.dateTime(json, 'endTime') ?? DateTime.now(),
        meetLink: JsonRead.string(json, 'meetLink'),
        status: JsonRead.string(json, 'status') ?? '',
        symptoms: JsonRead.string(json, 'symptoms'),
      );
}
