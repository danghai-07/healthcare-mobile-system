import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<bool> updateUserProfile(int userId, UpdateProfileRequest request);
  Future<bool> changePassword(int userId, ChangePasswordRequest request);
}
