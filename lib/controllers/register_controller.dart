import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/routes/app_routes.dart';

/// Register Controller
/// 
/// Handles user registration logic
class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// Register user
  Future<void> register() async {
    // Validate inputs
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await _apiService.register({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
      });

      if (response != null && response.statusCode == 201) {
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
          
          Get.snackbar('Success', 'Registration successful');
          Get.offAllNamed(AppRoutes.dashboard);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Registration failed');
        }
      } else {
        Get.snackbar('Error', 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
