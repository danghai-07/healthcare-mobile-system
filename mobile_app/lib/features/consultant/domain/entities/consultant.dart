import 'specialty.dart';

export 'specialty.dart';

class Consultant {
  const Consultant({
    required this.consultantId,
    required this.fullName,
    required this.email,
    this.avatar,
    this.gender,
    this.specialties = const [],
    this.freeSlots = const [],
  });

  final String? avatar;
  final int consultantId;
  final String fullName;
  final String email;
  final String? gender;
  final List<Specialty> specialties;
  final List<FreeSlot> freeSlots;
}

class FreeSlot {
  const FreeSlot({
    required this.date,
    required this.start,
    required this.end,
  });

  final DateTime date;
  final DateTime start;
  final DateTime end;
}

class ConsultantDetail extends Consultant {
  const ConsultantDetail({
    required super.consultantId,
    required super.fullName,
    required super.email,
    super.avatar,
    super.gender,
    super.specialties,
    super.freeSlots,
    this.weeklySchedules = const [],
    this.overrideSchedules = const [],
  });

  final List<WeeklySchedule> weeklySchedules;
  final List<WeeklyOverrideSchedule> overrideSchedules;
}

class WeeklySchedule {
  const WeeklySchedule({
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
}

class WeeklyOverrideSchedule {
  const WeeklyOverrideSchedule({
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
}
