import '../../domain/entities/consultant.dart';
import '../dtos/consultant_detail_dto.dart';
import '../dtos/consultant_with_specialty_dto.dart';
import '../dtos/specialty_dto.dart';
import '../dtos/weekly_override_schedule_dto.dart';
import '../dtos/weekly_schedule_dto.dart';

class ConsultantModel {
  const ConsultantModel._();

  static Consultant fromDto(ConsultantWithSpecialtyDto dto) => Consultant(
        avatar: dto.avatar,
        consultantId: dto.consultantId,
        fullName: dto.fullName,
        email: dto.email,
        gender: dto.gender,
        specialties: dto.specialties.map(SpecialtyModel.fromDto).toList(),
        freeSlots: dto.freeSlots
            .map(
              (slot) => FreeSlot(
                date: slot.date,
                start: slot.start,
                end: slot.end,
              ),
            )
            .toList(),
      );

  static ConsultantDetail fromDetailDto(ConsultantDetailDto dto) =>
      ConsultantDetail(
        avatar: dto.avatar,
        consultantId: dto.consultantId,
        fullName: dto.fullName,
        email: dto.email,
        gender: dto.gender,
        specialties: dto.specialties.map(SpecialtyModel.fromDto).toList(),
        freeSlots: dto.freeSlots
            .map(
              (slot) => FreeSlot(
                date: slot.date,
                start: slot.start,
                end: slot.end,
              ),
            )
            .toList(),
        weeklySchedules:
            dto.weeklySchedules.map(_weeklyScheduleFromDto).toList(),
        overrideSchedules:
            dto.overrideSchedules.map(_overrideScheduleFromDto).toList(),
      );

  static WeeklySchedule _weeklyScheduleFromDto(WeeklyScheduleDto dto) =>
      WeeklySchedule(
        weeklyScheduleId: dto.weeklyScheduleId,
        userId: dto.userId,
        dayOfWeek: dto.dayOfWeek,
        startTime: dto.startTime,
        endTime: dto.endTime,
        shiftType: dto.shiftType,
        note: dto.note,
      );

  static WeeklyOverrideSchedule _overrideScheduleFromDto(
    WeeklyOverrideScheduleDto dto,
  ) =>
      WeeklyOverrideSchedule(
        weeklyOverrideScheduleId: dto.weeklyOverrideScheduleId,
        userId: dto.userId,
        date: dto.date,
        overrideType: dto.overrideType,
        reason: dto.reason,
        shiftType: dto.shiftType,
        status: dto.status,
        userName: dto.userName,
        roleName: dto.roleName,
      );
}

class SpecialtyModel {
  const SpecialtyModel._();

  static Specialty fromDto(SpecialtyDto dto) => Specialty(
        id: dto.id,
        name: dto.name,
        description: dto.description,
        isDeleted: dto.isDeleted,
      );
}
