import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/google_login_dto.dart';
import '../dtos/google_token_request_dto.dart';
import '../dtos/login_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/register_dto.dart';
import '../dtos/register_response_dto.dart';
import '../dtos/reset_password_dto.dart';
import '../dtos/verify_otp_dto.dart';

class AuthApiService {
  AuthApiService(this._client);

  final DioClient _client;

  Future<LoginResponseDto> login(LoginDto dto) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: dto.toJson(),
    );

    final body = response.data;
    if (body == null) {
      throw const ApiException(
        message: 'Phản hồi đăng nhập trống.',
        code: 'empty_login_response',
      );
    }

    final loginResponse = LoginResponseDto.fromJson(body);
    if (loginResponse.success == false) {
      throw ApiException(
        message: loginResponse.message ?? 'Đăng nhập thất bại.',
        code: 'login_failed',
      );
    }

    return loginResponse;
  }

  Future<RegisterResponseDto> register(RegisterDto dto) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: dto.toJson(),
    );

    final body = response.data;
    if (body == null) {
      throw const ApiException(
        message: 'Phản hồi đăng ký trống.',
        code: 'empty_register_response',
      );
    }

    final registerResponse = RegisterResponseDto.fromJson(body);
    if (registerResponse.success == false) {
      throw ApiException(
        message: registerResponse.message ?? 'Đăng ký thất bại.',
        code: 'register_failed',
      );
    }

    return registerResponse;
  }

  Future<GoogleLoginDto> googleLogin(GoogleTokenRequestDto dto) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.googleLogin,
      data: dto.toJson(),
    );

    return ResponseParser.parseObject(
      response.data,
      GoogleLoginDto.fromJson,
      expectEnvelope: true,
    );
  }

  Future<void> sendOtpByUserId(int userId) async {
    await _client.post<void>(
      '${ApiEndpoints.otpSendByUserId}/$userId',
    );
  }

  Future<void> sendOtpByEmail(String email) async {
    await _client.post<void>(
      ApiEndpoints.otpSendByEmail,
      data: email,
    );
  }

  Future<bool> verifyOtp(VerifyOtpDto dto) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.otpVerify,
      data: dto.toJson(),
    );

    final body = response.data;
    if (body is bool) {
      return body;
    }
    if (body is Map<String, dynamic>) {
      return body['success'] as bool? ?? true;
    }
    return true;
  }

  Future<bool> resetPassword(ResetPasswordDto dto) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.userResetPassword,
      data: dto.toJson(),
    );
    final body = response.data;
    if (body is bool) {
      return body;
    }
    return true;
  }
}
