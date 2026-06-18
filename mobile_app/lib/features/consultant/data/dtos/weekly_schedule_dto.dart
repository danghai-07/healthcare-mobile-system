import '../../../../core/utils/json_read.dart';

/// Swagger: WeeklyScheduleDTO
class WeeklyScheduleDto {
  const WeeklyScheduleDto({
    required this.weeklyScheduleId,
    required this.userId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.shiftType,
    this.note,
  });

  final int weeklyScheduleId;
  final int userId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final int shiftType;
  final String? note;

  factory WeeklyScheduleDto.fromJson(Map<String, dynamic> json) =>
      WeeklyScheduleDto(
        weeklyScheduleId: JsonRead.intValue(json, 'weeklyScheduleId') ?? 0,
        userId: JsonRead.intValue(json, 'userId') ?? 0,
        dayOfWeek: JsonRead.intValue(json, 'dayOfWeek') ?? 0,
        startTime: JsonRead.string(json, 'startTime') ?? '',
        endTime: JsonRead.string(json, 'endTime') ?? '',
        shiftType: JsonRead.intValue(json, 'shiftType') ?? 0,
        note: JsonRead.string(json, 'note'),
      );
}
