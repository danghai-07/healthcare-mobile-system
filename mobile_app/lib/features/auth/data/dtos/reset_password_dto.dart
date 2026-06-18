import '../../../../core/utils/json_read.dart';

/// Swagger: ResetPasswordRequestDTO
class ResetPasswordDto {
  const ResetPasswordDto({
    required this.email,
    required this.otpCode,
    required this.newPassword,
  });

  final String email;
  final String otpCode;
  final String newPassword;

  Map<String, dynamic> toJson() => {
        'email': email,
        'otpCode': otpCode,
        'newPassword': newPassword,
      };

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      ResetPasswordDto(
        email: JsonRead.string(json, 'email') ?? '',
        otpCode: JsonRead.string(json, 'otpCode') ?? '',
        newPassword: JsonRead.string(json, 'newPassword') ?? '',
      );
}
