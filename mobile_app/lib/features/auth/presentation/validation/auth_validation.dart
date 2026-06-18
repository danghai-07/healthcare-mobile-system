/// Client-side validation for auth forms (aligned with Swagger constraints).
abstract final class AuthValidation {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegex = RegExp(
    r'^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$',
  );

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập email.';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final trimmed = value ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    if (trimmed.length < minLength) {
      return 'Mật khẩu phải có ít nhất $minLength ký tự.';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    final trimmed = value?.trim().replaceAll(RegExp(r'\s+'), '') ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }
    if (!_phoneRegex.hasMatch(trimmed)) {
      return 'Số điện thoại không hợp lệ.';
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu.';
    }
    if (confirm != password) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }

  /// Normalizes Vietnamese phone numbers to `0xxxxxxxxx` for the API.
  static String normalizePhone(String phone) {
    var normalized = phone.trim().replaceAll(RegExp(r'\s+'), '');
    if (normalized.startsWith('+84')) {
      normalized = '0${normalized.substring(3)}';
    } else if (normalized.startsWith('84') && normalized.length > 10) {
      normalized = '0${normalized.substring(2)}';
    }
    return normalized;
  }
}
