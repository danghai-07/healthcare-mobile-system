import '../../../../core/utils/json_read.dart';

/// Swagger: LoginDTO
class LoginDto {
  const LoginDto({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
        email: JsonRead.string(json, 'email') ?? '',
        password: JsonRead.string(json, 'password') ?? '',
      );
}
