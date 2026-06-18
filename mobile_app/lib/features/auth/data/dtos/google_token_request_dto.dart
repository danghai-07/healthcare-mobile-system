import '../../../../core/utils/json_read.dart';

/// Swagger: GoogleTokenRequestDTO
class GoogleTokenRequestDto {
  const GoogleTokenRequestDto({this.idToken});

  final String? idToken;

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
      };

  factory GoogleTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      GoogleTokenRequestDto(
        idToken: JsonRead.string(json, 'idToken'),
      );
}
