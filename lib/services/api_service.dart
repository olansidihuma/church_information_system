import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:church_information_system/services/storage_service.dart';

/// API service for handling HTTP requests
/// 
/// Provides a centralized way to make API calls using Dio.
/// Automatically includes authentication tokens in requests.
class ApiService {
  late final Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();
  
  // Base URL - replace with your actual API URL
  static const String baseUrl = 'https://api.yourchurch.com/api/v1';
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _initInterceptors();
  }
  
  /// Initialize interceptors for request/response handling
  void _initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to requests
          final token = _storageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }
  
  /// Handle API errors
  void _handleError(DioException error) {
    String message = 'An error occurred';
    
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    } else if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          message = 'Bad request';
          break;
        case 401:
          message = 'Unauthorized';
          // Optionally logout user
          break;
        case 403:
          message = 'Forbidden';
          break;
        case 404:
          message = 'Not found';
          break;
        case 500:
          message = 'Server error';
          break;
        default:
          message = 'Error: ${error.response?.statusCode}';
      }
    }
    
    Get.snackbar('Error', message);
  }
  
  // Authentication Endpoints
  
  /// Login user
  Future<Response?> login(String email, String password) async {
    try {
      return await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
    } catch (e) {
      return null;
    }
  }
  
  /// Register new user
  Future<Response?> register(Map<String, dynamic> userData) async {
    try {
      return await _dio.post('/auth/register', data: userData);
    } catch (e) {
      return null;
    }
  }
  
  /// Logout user
  Future<Response?> logout() async {
    try {
      return await _dio.post('/auth/logout');
    } catch (e) {
      return null;
    }
  }
  
  // User Endpoints
  
  /// Get user profile
  Future<Response?> getUserProfile() async {
    try {
      return await _dio.get('/user/profile');
    } catch (e) {
      return null;
    }
  }
  
  /// Update user profile
  Future<Response?> updateUserProfile(Map<String, dynamic> data) async {
    try {
      return await _dio.put('/user/profile', data: data);
    } catch (e) {
      return null;
    }
  }
  
  // Church Activities Endpoints
  
  /// Get church activities/services
  Future<Response?> getActivities() async {
    try {
      return await _dio.get('/activities');
    } catch (e) {
      return null;
    }
  }
  
  /// Get activity detail
  Future<Response?> getActivityDetail(String activityId) async {
    try {
      return await _dio.get('/activities/$activityId');
    } catch (e) {
      return null;
    }
  }
  
  // Service Request Endpoints
  
  /// Submit prayer request
  Future<Response?> submitPrayerRequest(Map<String, dynamic> data) async {
    try {
      return await _dio.post('/services/prayer-request', data: data);
    } catch (e) {
      return null;
    }
  }
  
  /// Submit baptism request
  Future<Response?> submitBaptismRequest(Map<String, dynamic> data) async {
    try {
      return await _dio.post('/services/baptism-request', data: data);
    } catch (e) {
      return null;
    }
  }
  
  /// Submit child dedication request
  Future<Response?> submitChildDedicationRequest(Map<String, dynamic> data) async {
    try {
      return await _dio.post('/services/child-dedication', data: data);
    } catch (e) {
      return null;
    }
  }
  
  // Family Management Endpoints
  
  /// Get family members
  Future<Response?> getFamilyMembers() async {
    try {
      return await _dio.get('/family/members');
    } catch (e) {
      return null;
    }
  }
  
  /// Add family member
  Future<Response?> addFamilyMember(Map<String, dynamic> data) async {
    try {
      return await _dio.post('/family/members', data: data);
    } catch (e) {
      return null;
    }
  }
  
  // Chat Endpoints
  
  /// Get chat messages
  Future<Response?> getChatMessages() async {
    try {
      return await _dio.get('/chat/messages');
    } catch (e) {
      return null;
    }
  }
  
  /// Send chat message
  Future<Response?> sendChatMessage(Map<String, dynamic> data) async {
    try {
      return await _dio.post('/chat/messages', data: data);
    } catch (e) {
      return null;
    }
  }
  
  // Notification Endpoints
  
  /// Get notifications
  Future<Response?> getNotifications() async {
    try {
      return await _dio.get('/notifications');
    } catch (e) {
      return null;
    }
  }
  
  /// Mark notification as read
  Future<Response?> markNotificationAsRead(String notificationId) async {
    try {
      return await _dio.put('/notifications/$notificationId/read');
    } catch (e) {
      return null;
    }
  }
  
  /// Respond to service notification
  Future<Response?> respondToServiceNotification(
    String notificationId,
    bool attending,
  ) async {
    try {
      return await _dio.post('/notifications/$notificationId/respond', data: {
        'attending': attending,
      });
    } catch (e) {
      return null;
    }
  }
}
