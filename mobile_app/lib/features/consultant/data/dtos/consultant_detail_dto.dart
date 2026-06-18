import '../../../../core/utils/json_read.dart';
import 'consultant_with_specialty_dto.dart';
import 'weekly_override_schedule_dto.dart';
import 'weekly_schedule_dto.dart';

class ConsultantDetailDto extends ConsultantWithSpecialtyDto {
  ConsultantDetailDto({
    super.avatar,
    required super.consultantId,
    required super.fullName,
    required super.email,
    super.gender,
    super.specialties,
    super.freeSlots,
    this.weeklySchedules = const [],
    this.overrideSchedules = const [],
  });

  final List<WeeklyScheduleDto> weeklySchedules;
  final List<WeeklyOverrideScheduleDto> overrideSchedules;

  factory ConsultantDetailDto.fromJson(Map<String, dynamic> json) =>
      ConsultantDetailDto(
        avatar: JsonRead.string(json, 'avatar'),
        consultantId: JsonRead.intValue(json, 'consultantId') ?? 0,
        fullName: JsonRead.string(json, 'fullName') ?? '',
        email: JsonRead.string(json, 'email') ?? '',
        gender: JsonRead.string(json, 'gender'),
        specialties: ConsultantWithSpecialtyDto.fromJson(json).specialties,
        freeSlots: ConsultantWithSpecialtyDto.fromJson(json).freeSlots,
        weeklySchedules: JsonRead.mapList(json['weeklySchedules'])
            .map(WeeklyScheduleDto.fromJson)
            .toList(),
        overrideSchedules: JsonRead.mapList(json['overrideSchedules'])
            .map(WeeklyOverrideScheduleDto.fromJson)
            .toList(),
      );
}
