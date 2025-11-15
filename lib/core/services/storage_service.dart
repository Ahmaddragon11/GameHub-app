import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A class to hold all keys for SharedPreferences to avoid typos
class StorageKeys {
  static const String themeMode = 'themeMode';
  static const String soundEnabled = 'soundEnabled';
  static const String userId = 'userId';
  static const String isGuest = 'isGuest';
  static const String isFirstTime = 'isFirstTime';
  static const String language = 'language';
}

class StorageService extends GetxService {
  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception("SharedPreferences has not been initialized. Call init() first.");
    }
    return _prefs!;
  }

  /// Writes a value to SharedPreferences.
  Future<bool> write(String key, dynamic value) async {
    if (value is String) {
      return await _preferences.setString(key, value);
    } else if (value is int) {
      return await _preferences.setInt(key, value);
    } else if (value is bool) {
      return await _preferences.setBool(key, value);
    } else if (value is double) {
      return await _preferences.setDouble(key, value);
    } else if (value is List<String>) {
      return await _preferences.setStringList(key, value);
    } else {
      throw ArgumentError("Unsupported value type");
    }
  }

  /// Reads a value from SharedPreferences.
  T? read<T>(String key) {
    final value = _preferences.get(key);
    if (value is T) {
      return value;
    } 
    return null;
  }

  /// Removes a value from SharedPreferences.
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Clears all data from SharedPreferences.
  Future<bool> clear() async {
    return await _preferences.clear();
  }
  
  // --- Helper Methods ---

  Future<String?> getUserId() async {
    return read<String>(StorageKeys.userId);
  }

  Future<void> setUserId(String userId) async {
    await write(StorageKeys.userId, userId);
  }

  Future<bool> isGuestUser() async {
    return read<bool>(StorageKeys.isGuest) ?? true;
  }
}
