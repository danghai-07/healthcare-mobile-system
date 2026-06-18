import '../../../../core/utils/json_read.dart';

/// Swagger: WeeklyOverrideScheduleDTO
class WeeklyOverrideScheduleDto {
  const WeeklyOverrideScheduleDto({
    required this.weeklyOverrideScheduleId,
    required this.userId,
    required this.date,
    this.overrideType,
    this.reason,
    this.shiftType,
    this.status,
    this.userName,
    this.roleName,
  });

  final int weeklyOverrideScheduleId;
  final int userId;
  final DateTime date;
  final String? overrideType;
  final String? reason;
  final int? shiftType;
  final String? status;
  final String? userName;
  final String? roleName;

  factory WeeklyOverrideScheduleDto.fromJson(Map<String, dynamic> json) =>
      WeeklyOverrideScheduleDto(
        weeklyOverrideScheduleId:
            JsonRead.intValue(json, 'weeklyOverrideScheduleId') ?? 0,
        userId: JsonRead.intValue(json, 'userId') ?? 0,
        date: JsonRead.dateTime(json, 'date') ?? DateTime.now(),
        overrideType: JsonRead.string(json, 'overrideType'),
        reason: JsonRead.string(json, 'reason'),
        shiftType: JsonRead.intValue(json, 'shiftType'),
        status: JsonRead.string(json, 'status'),
        userName: JsonRead.string(json, 'userName'),
        roleName: JsonRead.string(json, 'roleName'),
      );
}
