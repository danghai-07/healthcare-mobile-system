import '../../../../core/utils/json_read.dart';

class AppointmentListItemDto {
  const AppointmentListItemDto({
    required this.appointmentId,
    required this.memberId,
    required this.memberName,
    required this.consultantId,
    required this.consultantName,
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
  final DateTime startTime;
  final DateTime endTime;
  final String? meetLink;
  final String status;
  final String? symptoms;

  factory AppointmentListItemDto.fromJson(Map<String, dynamic> json) =>
      AppointmentListItemDto(
        appointmentId: JsonRead.intValue(json, 'appointmentId') ?? 0,
        memberId: JsonRead.intValue(json, 'memberId') ?? 0,
        memberName: JsonRead.string(json, 'memberName') ?? '',
        consultantId: JsonRead.intValue(json, 'consultantId') ?? 0,
        consultantName: JsonRead.string(json, 'consultantName') ?? '',
        startTime: JsonRead.dateTime(json, 'startTime') ?? DateTime.now(),
        endTime: JsonRead.dateTime(json, 'endTime') ?? DateTime.now(),
        meetLink: JsonRead.string(json, 'meetLink'),
        status: JsonRead.string(json, 'status') ?? '',
        symptoms: JsonRead.string(json, 'symptoms'),
      );
}
