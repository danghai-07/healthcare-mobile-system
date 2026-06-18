/// Centralized GoRouter path constants.
abstract final class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';

  static const String consultants = '/consultants';
  static const String consultantDetail = '/consultants/:id';
  static const String consultantSlotSelection = '/consultants/:id/book';
  static const String bookingConfirm = '/booking/confirm';

  static const String appointments = '/appointments';
  static const String appointmentDetail = '/appointments/:id';
  static const String appointmentTestRecordDetail =
      '/appointments/test-records/:recordId';

  static const String medicalTests = '/medical-tests';
  static const String medicalTestDetail = '/medical-tests/:id';
  static const String medicalTestBooking = '/medical-tests/:id/book';
  static const String medicalTestRecordDetail =
      '/medical-tests/records/:recordId';

  static const String blogs = '/blogs';
  static const String blogDetail = '/blogs/:id';

  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';

  /// Routes that require an authenticated session.
  static const Set<String> protectedPrefixes = {
    home,
    consultants,
    appointments,
    medicalTests,
    blogs,
    profile,
    bookingConfirm,
  };

  /// Auth-only routes redirected away from when already signed in.
  static const Set<String> authOnlyRoutes = {
    login,
    register,
    forgotPassword,
  };

  static bool isProtected(String location) {
    if (authOnlyRoutes.contains(location)) {
      return false;
    }
    for (final prefix in protectedPrefixes) {
      if (location == prefix || location.startsWith('$prefix/')) {
        return true;
      }
    }
    return false;
  }
}
