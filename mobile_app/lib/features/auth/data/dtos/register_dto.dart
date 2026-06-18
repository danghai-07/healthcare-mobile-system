import '../../../../core/utils/json_read.dart';

/// Swagger: RegisterDTO
class RegisterDto {
  const RegisterDto({
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  final String email;
  final String phoneNumber;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      };

  factory RegisterDto.fromJson(Map<String, dynamic> json) => RegisterDto(
        email: JsonRead.string(json, 'email') ?? '',
        phoneNumber: JsonRead.string(json, 'phoneNumber') ?? '',
        password: JsonRead.string(json, 'password') ?? '',
      );
}
