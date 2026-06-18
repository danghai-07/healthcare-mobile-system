import 'package:flutter/foundation.dart';

import '../../../../app/di/app_dependency_scope.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/dtos/login_dto.dart';
import '../../data/dtos/register_dto.dart';
import '../../domain/repositories/auth_repository.dart';
import '../validation/auth_validation.dart';

/// MVP presenter for login and registration flows.
class AuthPresenter extends ChangeNotifier {
  AuthPresenter({
    required AuthRepository authRepository,
    required SessionAuthStateReader sessionReader,
  })  : _authRepository = authRepository,
        _sessionReader = sessionReader;

  final AuthRepository _authRepository;
  final SessionAuthStateReader _sessionReader;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  String? _emailError;
  String? _passwordError;
  String? _phoneError;
  String? _confirmPasswordError;
  String? _otpError;
  String? _newPasswordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get phoneError => _phoneError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get otpError => _otpError;
  String? get newPasswordError => _newPasswordError;

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    _clearFieldErrors();
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Validates and submits login. Returns `true` when session is established.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (!_validateLogin(email: email, password: password)) {
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      await _authRepository.login(
        LoginDto(
          email: email.trim(),
          password: password,
        ),
      );
      await _sessionReader.refresh();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể đăng nhập. Vui lòng thử lại.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Validates and submits registration. Returns `true` on success.
  Future<bool> register({
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    if (!_validateRegister(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    )) {
      return false;
    }

    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      final userId = await _authRepository.register(
        RegisterDto(
          email: email.trim(),
          phoneNumber: AuthValidation.normalizePhone(phoneNumber),
          password: password,
        ),
      );

      if (userId <= 0) {
        _errorMessage = 'Đăng ký không thành công. Vui lòng thử lại.';
        return false;
      }

      _successMessage = 'Đăng ký thành công! Vui lòng đăng nhập.';
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể đăng ký. Vui lòng thử lại.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sends OTP to the member email for password recovery.
  Future<bool> sendForgotPasswordOtp({required String email}) async {
    _clearFieldErrors();
    _emailError = AuthValidation.email(email);
    if (_emailError != null) {
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      await _authRepository.sendOtpByEmail(email.trim());
      _successMessage = 'Mã OTP đã được gửi đến email của bạn.';
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể gửi mã OTP. Vui lòng thử lại.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Resets password using email OTP verification.
  Future<bool> resetPasswordWithOtp({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _clearFieldErrors();
    _emailError = AuthValidation.email(email);
    _otpError = otpCode.trim().isEmpty ? 'Vui lòng nhập mã OTP.' : null;
    _newPasswordError = AuthValidation.password(newPassword);
    _confirmPasswordError =
        AuthValidation.confirmPassword(newPassword, confirmPassword);

    if (_emailError != null ||
        _otpError != null ||
        _newPasswordError != null ||
        _confirmPasswordError != null) {
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      final success = await _authRepository.resetPassword(
        email: email.trim(),
        otpCode: otpCode.trim(),
        newPassword: newPassword,
      );

      if (!success) {
        _errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn.';
        return false;
      }

      _successMessage = 'Đặt lại mật khẩu thành công. Vui lòng đăng nhập.';
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể đặt lại mật khẩu. Vui lòng thử lại.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  bool _validateLogin({
    required String email,
    required String password,
  }) {
    _clearFieldErrors();
    _emailError = AuthValidation.email(email);
    _passwordError = AuthValidation.password(password, minLength: 1);

    final isValid = _emailError == null && _passwordError == null;
    notifyListeners();
    return isValid;
  }

  bool _validateRegister({
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    _clearFieldErrors();
    _emailError = AuthValidation.email(email);
    _phoneError = AuthValidation.phoneNumber(phoneNumber);
    _passwordError = AuthValidation.password(password);
    _confirmPasswordError =
        AuthValidation.confirmPassword(password, confirmPassword);

    final isValid = _emailError == null &&
        _phoneError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
    notifyListeners();
    return isValid;
  }

  void _clearFieldErrors() {
    _emailError = null;
    _passwordError = null;
    _phoneError = null;
    _confirmPasswordError = null;
    _otpError = null;
    _newPasswordError = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
