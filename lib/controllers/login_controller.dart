import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/routes/app_routes.dart';

/// Login Controller
/// 
/// Handles login logic and authentication
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Login user
  Future<void> login() async {
    // Validate inputs
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await _apiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true) {
          final token = data['data']['token'];
          final user = data['data']['user'];
          
          // Save user data
          await _storageService.saveAuthToken(token);
          await _storageService.saveUserId(user['id'].toString());
          await _storageService.saveUserName(user['name']);
          await _storageService.saveUserEmail(user['email']);
          await _storageService.setLoggedIn(true);
          
          Get.snackbar('Success', 'Login successful');
          Get.offAllNamed(AppRoutes.dashboard);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Login failed');
        }
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
