import '../entities/user_session.dart';
import '../../data/dtos/login_dto.dart';
import '../../data/dtos/register_dto.dart';
import '../../data/dtos/google_token_request_dto.dart';
import '../../data/dtos/verify_otp_dto.dart';

abstract interface class AuthRepository {
  Future<UserSession> login(LoginDto dto);
  Future<int> register(RegisterDto dto);
  Future<UserSession> googleLogin(GoogleTokenRequestDto dto);
  Future<void> sendOtpByUserId(int userId);
  Future<void> sendOtpByEmail(String email);
  Future<bool> verifyOtp(VerifyOtpDto dto);
  Future<bool> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  });
  Future<void> logout();
  Future<UserSession?> getCurrentSession();
}
