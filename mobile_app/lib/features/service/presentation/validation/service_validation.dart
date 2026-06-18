import '../../../auth/presentation/validation/auth_validation.dart';

/// Client-side validation for medical test booking forms.
abstract final class ServiceValidation {
  static String? fullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập họ tên.';
    }
    if (trimmed.length < 2) {
      return 'Họ tên quá ngắn.';
    }
    return null;
  }

  static String? gender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn giới tính.';
    }
    return null;
  }

  static String? phoneNumber(String? value) =>
      AuthValidation.phoneNumber(value);

  static String? dateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Vui lòng chọn ngày sinh.';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Ngày sinh không hợp lệ.';
    }
    return null;
  }

  static String? testDate(DateTime? value) {
    if (value == null) {
      return 'Vui lòng chọn ngày xét nghiệm.';
    }
    final today = DateTime.now();
    final dateOnly = DateTime(value.year, value.month, value.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    if (dateOnly.isBefore(todayOnly)) {
      return 'Ngày xét nghiệm phải từ hôm nay trở đi.';
    }
    return null;
  }

  static String? shift(int? shiftId) {
    if (shiftId == null) {
      return 'Vui lòng chọn ca xét nghiệm.';
    }
    return null;
  }
}
