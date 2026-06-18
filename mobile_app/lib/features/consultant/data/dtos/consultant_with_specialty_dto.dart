import '../../../../core/utils/json_read.dart';
import 'free_slot_dto.dart';
import 'specialty_dto.dart';

/// Consultant list item returned by GET /api/consultants.
class ConsultantWithSpecialtyDto {
  const ConsultantWithSpecialtyDto({
    this.avatar,
    required this.consultantId,
    required this.fullName,
    required this.email,
    this.gender,
    this.specialties = const [],
    this.freeSlots = const [],
  });

  final String? avatar;
  final int consultantId;
  final String fullName;
  final String email;
  final String? gender;
  final List<SpecialtyDto> specialties;
  final List<FreeSlotDto> freeSlots;

  factory ConsultantWithSpecialtyDto.fromJson(Map<String, dynamic> json) =>
      ConsultantWithSpecialtyDto(
        avatar: JsonRead.string(json, 'avatar'),
        consultantId: JsonRead.intValue(json, 'consultantId') ?? 0,
        fullName: JsonRead.string(json, 'fullName') ?? '',
        email: JsonRead.string(json, 'email') ?? '',
        gender: JsonRead.string(json, 'gender'),
        specialties: JsonRead.mapList(json['specialties'])
            .map(SpecialtyDto.fromJson)
            .toList(),
        freeSlots: JsonRead.mapList(json['freeSlots'])
            .map(FreeSlotDto.fromJson)
            .toList(),
      );
}
