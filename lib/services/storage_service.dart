import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service using SharedPreferences
/// 
/// Provides methods to store and retrieve data locally on the device.
/// Used for saving user session, preferences, and cached data.
class StorageService extends GetxService {
  late SharedPreferences _prefs;
  
  /// Initialize the storage service
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserData = 'user_data';
  static const String keyNotificationEnabled = 'notification_enabled';
  
  // Auth Methods
  
  /// Save authentication token
  Future<bool> saveAuthToken(String token) async {
    return await _prefs.setString(keyAuthToken, token);
  }
  
  /// Get authentication token
  String? getAuthToken() {
    return _prefs.getString(keyAuthToken);
  }
  
  /// Save user ID
  Future<bool> saveUserId(String userId) async {
    return await _prefs.setString(keyUserId, userId);
  }
  
  /// Get user ID
  String? getUserId() {
    return _prefs.getString(keyUserId);
  }
  
  /// Save user name
  Future<bool> saveUserName(String name) async {
    return await _prefs.setString(keyUserName, name);
  }
  
  /// Get user name
  String? getUserName() {
    return _prefs.getString(keyUserName);
  }
  
  /// Save user email
  Future<bool> saveUserEmail(String email) async {
    return await _prefs.setString(keyUserEmail, email);
  }
  
  /// Get user email
  String? getUserEmail() {
    return _prefs.getString(keyUserEmail);
  }
  
  /// Set login status
  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(keyIsLoggedIn, value);
  }
  
  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(keyIsLoggedIn) ?? false;
  }
  
  /// Save complete user data as JSON string
  Future<bool> saveUserData(String userData) async {
    return await _prefs.setString(keyUserData, userData);
  }
  
  /// Get user data as JSON string
  String? getUserData() {
    return _prefs.getString(keyUserData);
  }
  
  // Settings Methods
  
  /// Enable/disable notifications
  Future<bool> setNotificationEnabled(bool enabled) async {
    return await _prefs.setBool(keyNotificationEnabled, enabled);
  }
  
  /// Check if notifications are enabled
  bool isNotificationEnabled() {
    return _prefs.getBool(keyNotificationEnabled) ?? true;
  }
  
  // General Methods
  
  /// Save a string value
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }
  
  /// Get a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  /// Save an integer value
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }
  
  /// Get an integer value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  /// Save a boolean value
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }
  
  /// Get a boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  /// Remove a specific key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
  
  /// Clear all stored data (logout)
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
  
  /// Logout user (clear auth data)
  Future<void> logout() async {
    await remove(keyAuthToken);
    await remove(keyUserId);
    await remove(keyUserName);
    await remove(keyUserEmail);
    await setLoggedIn(false);
    await remove(keyUserData);
  }
}
