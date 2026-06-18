import '../../../../core/utils/json_read.dart';

/// Swagger: UserDTO
class UserDto {
  const UserDto({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.doB,
    this.gender,
    this.address,
    this.avatar,
    this.password,
  });

  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final DateTime? doB;
  final String? gender;
  final String? address;
  final String? avatar;
  final String? password;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'doB': doB != null ? _formatDate(doB!) : null,
        'gender': gender,
        'address': address,
        'avatar': avatar,
        'password': password,
      };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        fullName: JsonRead.string(json, 'fullName'),
        email: JsonRead.string(json, 'email'),
        phoneNumber: JsonRead.string(json, 'phoneNumber'),
        doB: JsonRead.dateTime(json, 'doB'),
        gender: JsonRead.string(json, 'gender'),
        address: JsonRead.string(json, 'address'),
        avatar: JsonRead.string(json, 'avatar'),
        password: JsonRead.string(json, 'password'),
      );

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Swagger: ChangePasswordRequestDTO
class ChangePasswordRequestDto {
  const ChangePasswordRequestDto({
    this.oldPassword,
    this.newPassword,
  });

  final String? oldPassword;
  final String? newPassword;

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };

  factory ChangePasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequestDto(
        oldPassword: JsonRead.string(json, 'oldPassword'),
        newPassword: JsonRead.string(json, 'newPassword'),
      );
}

/// User profile response from GET /api/user/get/{userId}.
class UserInfoDto {
  const UserInfoDto({
    required this.userId,
    this.provider,
    this.googleId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.doB,
    this.gender,
    this.address,
    this.createDate,
    this.avatar,
    this.roleId,
    this.isActive = false,
    this.isAvailable = false,
  });

  final int userId;
  final String? provider;
  final String? googleId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final DateTime? doB;
  final String? gender;
  final String? address;
  final DateTime? createDate;
  final String? avatar;
  final String? roleId;
  final bool isActive;
  final bool isAvailable;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) => UserInfoDto(
        userId: JsonRead.intValue(json, 'userId') ?? 0,
        provider: JsonRead.string(json, 'provider'),
        googleId: JsonRead.string(json, 'googleId'),
        fullName: JsonRead.string(json, 'fullName'),
        email: JsonRead.string(json, 'email'),
        phoneNumber: JsonRead.string(json, 'phoneNumber'),
        doB: JsonRead.dateTime(json, 'doB'),
        gender: JsonRead.string(json, 'gender'),
        address: JsonRead.string(json, 'address'),
        createDate: JsonRead.dateTime(json, 'createDate'),
        avatar: JsonRead.string(json, 'avatar'),
        roleId: JsonRead.string(json, 'roleId'),
        isActive: JsonRead.boolValue(json, 'isActive') ?? false,
        isAvailable: JsonRead.boolValue(json, 'isAvailable') ?? false,
      );
}
