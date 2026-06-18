import '../../features/auth/domain/entities/user_session.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// Resolves the signed-in member id for booking and profile flows.
abstract final class SessionHelper {
  static Future<int?> resolveMemberId(AuthRepository authRepository) async {
    final session = await authRepository.getCurrentSession();
    return session?.userId;
  }

  static Future<UserSession?> requireSession(AuthRepository authRepository) =>
      authRepository.getCurrentSession();
}
