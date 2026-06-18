import '../../domain/entities/user_session.dart';
import '../dtos/google_login_dto.dart';
import '../dtos/login_response_dto.dart';

/// Maps auth DTOs to domain [UserSession].
class UserSessionModel {
  const UserSessionModel._();

  static UserSession fromLoginResponse(LoginResponseDto dto) {
    return UserSession(
      userId: dto.userId ?? 0,
      token: dto.token,
      refreshToken: dto.refreshToken,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      roleId: dto.roleId,
      avatarPath: dto.avatarPath,
      expiresAccessToken: dto.expiresAcessToken,
      expiresRefreshToken: dto.expiresRefreshToken,
    );
  }

  static UserSession fromGoogleLogin(GoogleLoginDto dto) {
    return UserSession(
      userId: dto.userId ?? 0,
      token: dto.token,
      refreshToken: dto.refreshToken,
      email: dto.email,
      fullName: dto.fullName,
      avatarPath: dto.picture,
      expiresAccessToken: dto.expiresAcessToken,
      expiresRefreshToken: dto.expiresRefreshToken,
    );
  }
}
