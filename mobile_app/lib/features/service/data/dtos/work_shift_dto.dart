import '../../domain/entities/work_shift.dart';

/// Swagger: WorkShiftDTO
class WorkShiftDto {
  const WorkShiftDto({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.currentBookings = 0,
    this.maxBookings = 0,
    this.isAvailable = true,
    this.status,
  });

  final int shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int currentBookings;
  final int maxBookings;
  final bool isAvailable;
  final String? status;

  factory WorkShiftDto.fromJson(Map<String, dynamic> json) => WorkShiftDto(
        shiftId: _int(json, 'shiftId') ?? 0,
        shiftName: json['shiftName'] as String? ?? '',
        startTime: json['startTime'] as String? ?? '',
        endTime: json['endTime'] as String? ?? '',
        currentBookings: _int(json, 'currentBookings') ?? 0,
        maxBookings: _int(json, 'maxBookings') ?? 0,
        isAvailable: json['isAvailable'] as bool? ?? true,
        status: json['status'] as String?,
      );

  WorkShift toEntity() => WorkShift(
        shiftId: shiftId,
        shiftName: shiftName,
        startTime: startTime,
        endTime: endTime,
        currentBookings: currentBookings,
        maxBookings: maxBookings,
        isAvailable: isAvailable,
        status: status,
      );

  static int? _int(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}
