import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/presentation/validation/auth_validation.dart';

void main() {
  group('AuthValidation', () {
    test('email rejects empty and invalid values', () {
      expect(AuthValidation.email(''), isNotNull);
      expect(AuthValidation.email('invalid'), isNotNull);
      expect(AuthValidation.email('user@example.com'), isNull);
    });

    test('password enforces minimum length', () {
      expect(AuthValidation.password(''), isNotNull);
      expect(AuthValidation.password('12345'), isNotNull);
      expect(AuthValidation.password('123456'), isNull);
    });

    test('phoneNumber validates Vietnamese numbers', () {
      expect(AuthValidation.phoneNumber(''), isNotNull);
      expect(AuthValidation.phoneNumber('123'), isNotNull);
      expect(AuthValidation.phoneNumber('0912345678'), isNull);
    });

    test('confirmPassword matches password', () {
      expect(
        AuthValidation.confirmPassword('secret', 'secret'),
        isNull,
      );
      expect(
        AuthValidation.confirmPassword('secret', 'other'),
        isNotNull,
      );
    });

    test('normalizePhone converts +84 prefix', () {
      expect(
        AuthValidation.normalizePhone('+84912345678'),
        '0912345678',
      );
    });
  });
}
