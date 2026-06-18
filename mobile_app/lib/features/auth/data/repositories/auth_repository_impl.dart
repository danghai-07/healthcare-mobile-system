import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dtos/google_token_request_dto.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';
import '../dtos/reset_password_dto.dart';
import '../dtos/verify_otp_dto.dart';
import '../models/user_session_model.dart';
import '../datasources/auth_local_datasource.dart';
import '../services/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService apiService,
    required AuthLocalDataSource localDataSource,
  })  : _apiService = apiService,
        _localDataSource = localDataSource;

  final AuthApiService _apiService;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<UserSession> login(LoginDto dto) async {
    final response = await _apiService.login(dto);
    final session = UserSessionModel.fromLoginResponse(response);

    await _localDataSource.saveSession(
      userId: session.userId,
      accessToken: session.token,
      refreshToken: session.refreshToken,
      email: session.email,
      roleId: session.roleId,
      avatarPath: session.avatarPath,
      accessTokenExpiry: session.expiresAccessToken,
      refreshTokenExpiry: session.expiresRefreshToken,
    );

    return session;
  }

  @override
  Future<int> register(RegisterDto dto) async {
    final response = await _apiService.register(dto);
    return response.userId ?? 0;
  }

  @override
  Future<UserSession> googleLogin(GoogleTokenRequestDto dto) async {
    final response = await _apiService.googleLogin(dto);
    final session = UserSessionModel.fromGoogleLogin(response);

    await _localDataSource.saveSession(
      userId: session.userId,
      accessToken: session.token,
      refreshToken: session.refreshToken,
      email: session.email,
      roleId: session.roleId,
      avatarPath: session.avatarPath,
      accessTokenExpiry: session.expiresAccessToken,
      refreshTokenExpiry: session.expiresRefreshToken,
    );

    return session;
  }

  @override
  Future<void> sendOtpByUserId(int userId) =>
      _apiService.sendOtpByUserId(userId);

  @override
  Future<void> sendOtpByEmail(String email) =>
      _apiService.sendOtpByEmail(email);

  @override
  Future<bool> verifyOtp(VerifyOtpDto dto) => _apiService.verifyOtp(dto);

  @override
  Future<bool> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) =>
      _apiService.resetPassword(
        ResetPasswordDto(
          email: email.trim(),
          otpCode: otpCode.trim(),
          newPassword: newPassword,
        ),
      );

  @override
  Future<void> logout() => _localDataSource.clearSession();

  @override
  Future<UserSession?> getCurrentSession() async {
    final userId = await _localDataSource.getUserId();
    final token = await _localDataSource.getAccessToken();
    if (userId == null || token == null) {
      return null;
    }

    return UserSession(
      userId: userId,
      token: token,
      refreshToken: await _localDataSource.getRefreshToken(),
    );
  }
}
