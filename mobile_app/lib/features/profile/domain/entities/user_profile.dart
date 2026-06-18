class UserProfile {
  const UserProfile({
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
}

class UpdateProfileRequest {
  const UpdateProfileRequest({
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
}

class ChangePasswordRequest {
  const ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
  });

  final String? oldPassword;
  final String? newPassword;
}
