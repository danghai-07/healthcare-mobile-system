import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';
import '../services/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._apiService);

  final ProfileApiService _apiService;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    final dto = await _apiService.getUserProfile(userId);
    return UserProfileModel.fromInfoDto(dto);
  }

  @override
  Future<bool> updateUserProfile(int userId, UpdateProfileRequest request) {
    final dto = UserProfileModel.toUpdateDto(request);
    return _apiService.updateUserProfile(userId, dto);
  }

  @override
  Future<bool> changePassword(int userId, ChangePasswordRequest request) {
    final dto = UserProfileModel.toChangePasswordDto(request);
    return _apiService.changePassword(userId, dto);
  }
}
