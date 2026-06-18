import '../../../../core/utils/json_read.dart';

/// Swagger: VerifyOtpDTO
class VerifyOtpDto {
  const VerifyOtpDto({
    this.userId,
    this.email,
    this.code,
  });

  final int? userId;
  final String? email;
  final String? code;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'code': code,
      };

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) => VerifyOtpDto(
        userId: JsonRead.intValue(json, 'userId'),
        email: JsonRead.string(json, 'email'),
        code: JsonRead.string(json, 'code'),
      );
}
