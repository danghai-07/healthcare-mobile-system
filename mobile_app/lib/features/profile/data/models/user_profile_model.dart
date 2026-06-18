import '../../domain/entities/user_profile.dart';
import '../dtos/user_dto.dart';

class UserProfileModel {
  const UserProfileModel._();

  static UserProfile fromInfoDto(UserInfoDto dto) => UserProfile(
        userId: dto.userId,
        provider: dto.provider,
        googleId: dto.googleId,
        fullName: dto.fullName,
        email: dto.email,
        phoneNumber: dto.phoneNumber,
        doB: dto.doB,
        gender: dto.gender,
        address: dto.address,
        createDate: dto.createDate,
        avatar: dto.avatar,
        roleId: dto.roleId,
        isActive: dto.isActive,
        isAvailable: dto.isAvailable,
      );

  static UserDto toUpdateDto(UpdateProfileRequest request) => UserDto(
        fullName: request.fullName,
        email: request.email,
        phoneNumber: request.phoneNumber,
        doB: request.doB,
        gender: request.gender,
        address: request.address,
        avatar: request.avatar,
        password: request.password,
      );

  static ChangePasswordRequestDto toChangePasswordDto(
    ChangePasswordRequest request,
  ) =>
      ChangePasswordRequestDto(
        oldPassword: request.oldPassword,
        newPassword: request.newPassword,
      );
}
