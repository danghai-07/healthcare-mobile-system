class Appointment {
  const Appointment({
    required this.appointmentId,
    required this.memberId,
    required this.consultantId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.memberName,
    this.consultantName,
    this.serviceId,
    this.serviceName,
    this.meetLink,
    this.symptoms,
  });

  final int appointmentId;
  final int memberId;
  final String? memberName;
  final int consultantId;
  final String? consultantName;
  final int? serviceId;
  final String? serviceName;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetLink;
  final String status;
  final String? symptoms;
}

class AppointmentDetail extends Appointment {
  const AppointmentDetail({
    required super.appointmentId,
    required super.memberId,
    required super.consultantId,
    required super.startTime,
    required super.endTime,
    required super.status,
    super.memberName,
    super.consultantName,
    super.serviceId,
    super.serviceName,
    super.meetLink,
    super.symptoms,
  });
}
