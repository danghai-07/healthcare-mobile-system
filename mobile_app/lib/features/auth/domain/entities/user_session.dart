/// Authenticated user session for the mobile application.
class UserSession {
  const UserSession({
    required this.userId,
    this.token,
    this.refreshToken,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.roleId,
    this.avatarPath,
    this.expiresAccessToken,
    this.expiresRefreshToken,
  });

  final int userId;
  final String? token;
  final String? refreshToken;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? roleId;
  final String? avatarPath;
  final DateTime? expiresAccessToken;
  final DateTime? expiresRefreshToken;

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}
