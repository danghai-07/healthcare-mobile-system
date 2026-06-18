import '../../../../core/utils/json_read.dart';

/// Swagger: BookTestServiceRecordDTO
class BookTestServiceRecordDto {
  const BookTestServiceRecordDto({
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

  Map<String, dynamic> toJson() => {
        'serviceId': serviceId,
        'fullName': fullName,
        'dob': _formatDate(dob),
        'gender': gender,
        'phoneNumber': phoneNumber,
        'testDate': _formatDate(testDate),
        'userId': userId,
        'shift': shift,
      };

  factory BookTestServiceRecordDto.fromJson(Map<String, dynamic> json) =>
      BookTestServiceRecordDto(
        serviceId: JsonRead.intValue(json, 'serviceId') ?? 0,
        fullName: JsonRead.string(json, 'fullName'),
        dob: JsonRead.dateTime(json, 'dob') ?? DateTime.now(),
        gender: JsonRead.string(json, 'gender'),
        phoneNumber: JsonRead.string(json, 'phoneNumber'),
        testDate: JsonRead.dateTime(json, 'testDate') ?? DateTime.now(),
        userId: JsonRead.intValue(json, 'userId') ?? 0,
        shift: JsonRead.intValue(json, 'shift') ?? 0,
      );

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class BookTestServiceResponseDto {
  const BookTestServiceResponseDto({
    this.testServiceRecordId,
    this.message,
  });

  final int? testServiceRecordId;
  final String? message;

  factory BookTestServiceResponseDto.fromJson(Map<String, dynamic> json) =>
      BookTestServiceResponseDto(
        testServiceRecordId: JsonRead.intValue(json, 'testServiceRecordID') ??
            JsonRead.intValue(json, 'testServiceRecordId'),
        message: JsonRead.string(json, 'message') ?? JsonRead.string(json, 'Message'),
      );
}
