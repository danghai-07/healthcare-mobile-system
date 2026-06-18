class MedicalService {
  const MedicalService({
    required this.serviceId,
    this.name,
    this.description,
    this.price,
  });

  final int serviceId;
  final String? name;
  final String? description;
  final double? price;
}

class TestServiceRecord {
  const TestServiceRecord({
    required this.testServiceRecordId,
    this.serviceId,
    this.serviceName,
    this.memberId,
    this.staffId,
    this.staffName,
    this.recordDate,
    this.status,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.fullNameOfMember,
    this.result,
    this.testDate,
    this.timeSlot,
    this.notes,
  });

  final int testServiceRecordId;
  final int? serviceId;
  final String? serviceName;
  final int? memberId;
  final int? staffId;
  final String? staffName;
  final DateTime? recordDate;
  final String? status;
  final DateTime? dob;
  final String? gender;
  final String? phoneNumber;
  final String? fullNameOfMember;
  final String? result;
  final DateTime? testDate;
  final String? timeSlot;
  final String? notes;
}

class BookTestServiceRequest {
  const BookTestServiceRequest({
    required this.serviceId,
    required this.dob,
    required this.testDate,
    required this.userId,
    required this.shift,
    this.fullName,
    this.gender,
    this.phoneNumber,
  });

  final int serviceId;
  final String? fullName;
  final DateTime dob;
  final String? gender;
  final String? phoneNumber;
  final DateTime testDate;
  final int userId;
  final int shift;
}
