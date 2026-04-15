import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/storage_keys.dart';

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return AuthLocalStorage();
});

/// Secure local storage for auth tokens and session data.
class AuthLocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ─── Token Management ──────────────────────────────────────────

  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }

  // ─── User Session Data ─────────────────────────────────────────

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: StorageKeys.userId);
  }

  Future<void> saveStoreId(String storeId) async {
    await _storage.write(key: StorageKeys.storeId, value: storeId);
  }

  Future<String?> getStoreId() async {
    return _storage.read(key: StorageKeys.storeId);
  }

  Future<void> saveOrganizationId(String orgId) async {
    await _storage.write(key: StorageKeys.organizationId, value: orgId);
  }

  Future<String?> getOrganizationId() async {
    return _storage.read(key: StorageKeys.organizationId);
  }

  Future<void> saveLocale(String locale) async {
    await _storage.write(key: StorageKeys.locale, value: locale);
  }

  Future<String?> getLocale() async {
    return _storage.read(key: StorageKeys.locale);
  }

  // ─── Onboarding ────────────────────────────────────────────────

  Future<void> setOnboardingComplete(bool complete) async {
    await _storage.write(key: StorageKeys.onboardingComplete, value: complete.toString());
  }

  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: StorageKeys.onboardingComplete);
    return value == 'true';
  }

  // ─── Clear All ─────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Save all session data after login.
  Future<void> saveSession({
    required String token,
    required String userId,
    String? storeId,
    String? organizationId,
    String? locale,
  }) async {
    await saveToken(token);
    await saveUserId(userId);
    if (storeId != null) await saveStoreId(storeId);
    if (organizationId != null) await saveOrganizationId(organizationId);
    if (locale != null) await saveLocale(locale);
  }
}
