import '../../../../core/utils/json_read.dart';

/// Login API response (flat envelope from POST /api/login).
class LoginResponseDto {
  const LoginResponseDto({
    this.success,
    this.token,
    this.refreshToken,
    this.userId,
    this.email,
    this.phoneNumber,
    this.roleId,
    this.avatarPath,
    this.expiresAcessToken,
    this.expiresRefreshToken,
    this.message,
  });

  final bool? success;
  final String? token;
  final String? refreshToken;
  final int? userId;
  final String? email;
  final String? phoneNumber;
  final String? roleId;
  final String? avatarPath;
  final DateTime? expiresAcessToken;
  final DateTime? expiresRefreshToken;
  final String? message;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        success: JsonRead.boolValue(json, 'success'),
        token: JsonRead.string(json, 'token'),
        refreshToken: JsonRead.string(json, 'refreshToken'),
        userId: JsonRead.intValue(json, 'userId'),
        email: JsonRead.string(json, 'email'),
        phoneNumber: JsonRead.string(json, 'phoneNumber'),
        roleId: JsonRead.string(json, 'roleId'),
        avatarPath: JsonRead.string(json, 'avatarPath'),
        expiresAcessToken: JsonRead.dateTime(json, 'expiresAcessToken'),
        expiresRefreshToken: JsonRead.dateTime(json, 'expiresRefreshToken'),
        message: JsonRead.string(json, 'message'),
      );
}
