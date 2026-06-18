import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/network/auth_interceptor.dart';

/// Thin wrapper over SharedPreferences for testability.
abstract interface class AuthPreferences {
  Future<String?> getString(String key);
  Future<int?> getInt(String key);
  Future<void> setString(String key, String? value);
  Future<void> setInt(String key, int value);
  Future<void> remove(String key);
}

class SharedPrefsAuthPreferences implements AuthPreferences {
  SharedPrefsAuthPreferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPrefsAuthPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsAuthPreferences(prefs);
  }

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String? value) async {
    if (value == null) {
      await _prefs.remove(key);
      return;
    }
    await _prefs.setString(key, value);
  }
}

/// Persists auth tokens and implements [TokenProvider] for Dio.
class AuthLocalDataSource implements TokenProvider {
  AuthLocalDataSource(this._prefs);

  final AuthPreferences _prefs;

  Future<void> saveSession({
    required int userId,
    String? accessToken,
    String? refreshToken,
    String? email,
    String? roleId,
    String? avatarPath,
    DateTime? accessTokenExpiry,
    DateTime? refreshTokenExpiry,
  }) async {
    await _prefs.setString(StorageKeys.accessToken, accessToken);
    await _prefs.setString(StorageKeys.refreshToken, refreshToken);
    await _prefs.setInt(StorageKeys.userId, userId);
    await _prefs.setString(StorageKeys.email, email);
    await _prefs.setString(StorageKeys.roleId, roleId);
    await _prefs.setString(StorageKeys.avatarPath, avatarPath);
    if (accessTokenExpiry != null) {
      await _prefs.setString(
        StorageKeys.accessTokenExpiry,
        accessTokenExpiry.toIso8601String(),
      );
    }
    if (refreshTokenExpiry != null) {
      await _prefs.setString(
        StorageKeys.refreshTokenExpiry,
        refreshTokenExpiry.toIso8601String(),
      );
    }
  }

  Future<int?> getUserId() => _prefs.getInt(StorageKeys.userId);

  @override
  Future<String?> getAccessToken() => _prefs.getString(StorageKeys.accessToken);

  @override
  Future<String?> getRefreshToken() =>
      _prefs.getString(StorageKeys.refreshToken);

  @override
  Future<void> clearSession() async {
    await _prefs.remove(StorageKeys.accessToken);
    await _prefs.remove(StorageKeys.refreshToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.email);
    await _prefs.remove(StorageKeys.roleId);
    await _prefs.remove(StorageKeys.avatarPath);
    await _prefs.remove(StorageKeys.accessTokenExpiry);
    await _prefs.remove(StorageKeys.refreshTokenExpiry);
  }
}
