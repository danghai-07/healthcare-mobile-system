import '../../../../core/utils/json_read.dart';

/// Google login user payload (POST /api/google-login data field).
class GoogleLoginDto {
  const GoogleLoginDto({
    this.userId,
    this.sub,
    this.fullName,
    this.picture,
    this.email,
    this.emailVerified,
    this.locale,
    this.token,
    this.refreshToken,
    this.expiresAcessToken,
    this.expiresRefreshToken,
  });

  final int? userId;
  final String? sub;
  final String? fullName;
  final String? picture;
  final String? email;
  final bool? emailVerified;
  final String? locale;
  final String? token;
  final String? refreshToken;
  final DateTime? expiresAcessToken;
  final DateTime? expiresRefreshToken;

  factory GoogleLoginDto.fromJson(Map<String, dynamic> json) => GoogleLoginDto(
        userId: JsonRead.intValue(json, 'userId'),
        sub: JsonRead.string(json, 'sub'),
        fullName: JsonRead.string(json, 'fullName'),
        picture: JsonRead.string(json, 'picture'),
        email: JsonRead.string(json, 'email'),
        emailVerified: JsonRead.boolValue(json, 'email_verified'),
        locale: JsonRead.string(json, 'locale'),
        token: JsonRead.string(json, 'token'),
        refreshToken: JsonRead.string(json, 'refreshToken'),
        expiresAcessToken: JsonRead.dateTime(json, 'expiresAcessToken'),
        expiresRefreshToken: JsonRead.dateTime(json, 'expiresRefreshToken'),
      );
}
