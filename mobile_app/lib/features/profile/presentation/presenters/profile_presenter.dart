import 'package:flutter/foundation.dart';

import '../../../../app/di/app_dependency_scope.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/session_helper.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../auth/presentation/validation/auth_validation.dart';
import 'profile_view_status.dart';

/// MVP presenter for viewing and updating the signed-in member profile.
class ProfilePresenter extends ChangeNotifier {
  ProfilePresenter({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
    required SessionAuthStateReader sessionReader,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        _sessionReader = sessionReader;

  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;
  final SessionAuthStateReader _sessionReader;

  ProfileViewStatus _status = ProfileViewStatus.idle;
  UserProfile? _profile;
  String? _errorMessage;
  String? _successMessage;
  bool _isSaving = false;
  bool _isChangingPassword = false;
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String? _gender;
  String _address = '';
  DateTime? _dateOfBirth;

  ProfileViewStatus get status => _status;
  UserProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isSaving => _isSaving;
  bool get isChangingPassword => _isChangingPassword;
  String? get oldPasswordError => _oldPasswordError;
  String? get newPasswordError => _newPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  String get fullName => _fullName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String? get gender => _gender;
  String get address => _address;
  DateTime? get dateOfBirth => _dateOfBirth;

  Future<void> loadProfile() async {
    _status = ProfileViewStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final session = await _authRepository.getCurrentSession();
      if (session == null || !session.isAuthenticated) {
        _errorMessage = 'Vui lòng đăng nhập để xem hồ sơ.';
        _status = ProfileViewStatus.error;
        notifyListeners();
        return;
      }

      _profile = await _profileRepository.getUserProfile(
        session.userId.toString(),
      );
      _syncFormFromProfile(_profile!);
      _status = ProfileViewStatus.success;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _status = ProfileViewStatus.error;
    } catch (_) {
      _errorMessage = 'Không thể tải hồ sơ cá nhân.';
      _status = ProfileViewStatus.error;
    }

    notifyListeners();
  }

  void setFullName(String value) {
    _fullName = value;
    _successMessage = null;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _successMessage = null;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    _successMessage = null;
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value;
    _successMessage = null;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    _successMessage = null;
    notifyListeners();
  }

  void setDateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    final userId = _profile?.userId;
    if (userId == null) {
      _errorMessage = 'Không xác định được tài khoản.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final success = await _profileRepository.updateUserProfile(
        userId,
        UpdateProfileRequest(
          fullName: _fullName.trim().isEmpty ? null : _fullName.trim(),
          email: _email.trim().isEmpty ? null : _email.trim(),
          phoneNumber:
              _phoneNumber.trim().isEmpty ? null : _phoneNumber.trim(),
          gender: _gender,
          address: _address.trim().isEmpty ? null : _address.trim(),
          doB: _dateOfBirth,
        ),
      );

      if (!success) {
        _errorMessage = 'Cập nhật hồ sơ không thành công.';
        return false;
      }

      await loadProfile();
      _successMessage = 'Đã cập nhật hồ sơ thành công.';
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể cập nhật hồ sơ.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _oldPasswordError = oldPassword.isEmpty
        ? 'Vui lòng nhập mật khẩu hiện tại.'
        : null;
    _newPasswordError = AuthValidation.password(newPassword);
    _confirmPasswordError =
        AuthValidation.confirmPassword(newPassword, confirmPassword);

    if (_oldPasswordError != null ||
        _newPasswordError != null ||
        _confirmPasswordError != null) {
      notifyListeners();
      return false;
    }

    final userId = _profile?.userId ??
        await SessionHelper.resolveMemberId(_authRepository);
    if (userId == null) {
      _errorMessage = 'Không xác định được tài khoản.';
      notifyListeners();
      return false;
    }

    _isChangingPassword = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final success = await _profileRepository.changePassword(
        userId,
        ChangePasswordRequest(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
      );

      if (!success) {
        _errorMessage = 'Mật khẩu hiện tại không đúng.';
        return false;
      }

      _successMessage = 'Đã đổi mật khẩu thành công.';
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể đổi mật khẩu.';
      return false;
    } finally {
      _isChangingPassword = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _sessionReader.refresh();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    _oldPasswordError = null;
    _newPasswordError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }

  void _syncFormFromProfile(UserProfile profile) {
    _fullName = profile.fullName ?? '';
    _email = profile.email ?? '';
    _phoneNumber = profile.phoneNumber ?? '';
    _gender = _normalizeGender(profile.gender);
    _address = profile.address ?? '';
    _dateOfBirth = profile.doB;
  }

  static String? _normalizeGender(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.toUpperCase();
    if (normalized.contains('FEMALE') || normalized.contains('NỮ')) {
      return 'Nữ';
    }
    if (normalized.contains('MALE') || normalized.contains('NAM')) {
      return 'Nam';
    }
    return value;
  }
}
