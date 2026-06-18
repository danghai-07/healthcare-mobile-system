import '../../../../core/utils/json_read.dart';

/// Register API response from POST /api/register.
class RegisterResponseDto {
  const RegisterResponseDto({
    this.success,
    this.message,
    this.userId,
  });

  final bool? success;
  final String? message;
  final int? userId;

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    int? userId;
    if (data is Map<String, dynamic>) {
      userId = JsonRead.intValue(data, 'userId');
    }

    return RegisterResponseDto(
      success: JsonRead.boolValue(json, 'success'),
      message: JsonRead.string(json, 'message'),
      userId: userId,
    );
  }
}
