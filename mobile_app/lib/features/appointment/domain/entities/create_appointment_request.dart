class CreateAppointmentRequest {
  const CreateAppointmentRequest({
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
}
