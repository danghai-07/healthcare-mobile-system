import '../../../../core/utils/json_read.dart';

class FreeSlotDto {
  const FreeSlotDto({
    required this.date,
    required this.start,
    required this.end,
  });

  final DateTime date;
  final DateTime start;
  final DateTime end;

  factory FreeSlotDto.fromJson(Map<String, dynamic> json) => FreeSlotDto(
        date: JsonRead.dateTime(json, 'date') ?? DateTime.now(),
        start: JsonRead.dateTime(json, 'start') ?? DateTime.now(),
        end: JsonRead.dateTime(json, 'end') ?? DateTime.now(),
      );
}
