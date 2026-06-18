import '../../../../core/utils/json_read.dart';

/// Swagger: SpecialtyDTO
class SpecialtyDto {
  const SpecialtyDto({
    this.id,
    this.name,
    this.description,
    this.isDeleted = false,
  });

  final int? id;
  final String? name;
  final String? description;
  final bool isDeleted;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'isDeleted': isDeleted,
      };

  factory SpecialtyDto.fromJson(Map<String, dynamic> json) => SpecialtyDto(
        id: JsonRead.intValue(json, 'id'),
        name: JsonRead.string(json, 'name'),
        description: JsonRead.string(json, 'description'),
        isDeleted: JsonRead.boolValue(json, 'isDeleted') ?? false,
      );
}
