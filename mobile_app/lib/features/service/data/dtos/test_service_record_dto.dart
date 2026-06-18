import '../../../../core/utils/json_read.dart';

/// Swagger: TestServiceRecord entity
class TestServiceRecordDto {
  const TestServiceRecordDto({
    required this.testServiceRecordId,
    this.serviceId,
    this.serviceName,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.fullNameOfMember,
    this.memberId,
    this.result,
    this.staffId,
    this.staffName,
    this.recordDate,
    this.testDate,
    this.timeSlot,
    this.notes,
    this.status,
  });

  final int testServiceRecordId;
  final int? serviceId;
  final String? serviceName;
  final DateTime? dob;
  final String? gender;
  final String? phoneNumber;
  final String? fullNameOfMember;
  final int? memberId;
  final String? result;
  final int? staffId;
  final String? staffName;
  final DateTime? recordDate;
  final DateTime? testDate;
  final String? timeSlot;
  final String? notes;
  final String? status;

  factory TestServiceRecordDto.fromJson(Map<String, dynamic> json) =>
      TestServiceRecordDto(
        testServiceRecordId:
            JsonRead.intValue(json, 'testServiceRecordId') ?? 0,
        serviceId: JsonRead.intValue(json, 'serviceId'),
        serviceName: JsonRead.string(json, 'serviceName'),
        dob: JsonRead.dateTime(json, 'dob'),
        gender: JsonRead.string(json, 'gender'),
        phoneNumber: JsonRead.string(json, 'phoneNumber'),
        fullNameOfMember: JsonRead.string(json, 'fullNameOfMember'),
        memberId: JsonRead.intValue(json, 'memberId'),
        result: JsonRead.string(json, 'result'),
        staffId: JsonRead.intValue(json, 'staffId'),
        staffName: JsonRead.string(json, 'staffName') ??
            _readStaffName(json['staff']),
        recordDate: JsonRead.dateTime(json, 'recordDate'),
        testDate: JsonRead.dateTime(json, 'testDate'),
        timeSlot: _readTimeSlot(json['timeSlot']),
        notes: JsonRead.string(json, 'notes'),
        status: JsonRead.string(json, 'status'),
      );

  static String? _readStaffName(Object? staff) {
    if (staff is Map<String, dynamic>) {
      return JsonRead.string(staff, 'fullName');
    }
    return null;
  }

  static String? _readTimeSlot(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}
