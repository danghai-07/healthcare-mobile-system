import '../../../../core/utils/json_read.dart';

/// Swagger: AppointmentCreateDto
class AppointmentCreateDto {
  const AppointmentCreateDto({
    required this.memberId,
    required this.serviceId,
    required this.consultantId,
    required this.startTime,
    required this.endTime,
    this.meetLink,
    this.symptoms,
  });

  final int memberId;
  final int serviceId;
  final int consultantId;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetLink;
  final String? symptoms;

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'serviceId': serviceId,
        'consultantId': consultantId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'meetLink': meetLink,
        'symptoms': symptoms,
      };

  factory AppointmentCreateDto.fromJson(Map<String, dynamic> json) =>
      AppointmentCreateDto(
        memberId: JsonRead.intValue(json, 'memberId') ?? 0,
        serviceId: JsonRead.intValue(json, 'serviceId') ?? 0,
        consultantId: JsonRead.intValue(json, 'consultantId') ?? 0,
        startTime: JsonRead.dateTime(json, 'startTime') ?? DateTime.now(),
        endTime: JsonRead.dateTime(json, 'endTime') ?? DateTime.now(),
        meetLink: JsonRead.string(json, 'meetLink'),
        symptoms: JsonRead.string(json, 'symptoms'),
      );
}
