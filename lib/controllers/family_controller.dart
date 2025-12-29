import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';

class FamilyController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final nameController = TextEditingController();
  final relationshipController = TextEditingController();
  final phoneController = TextEditingController();
  
  final familyMembers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getFamilyMembers();
      
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          familyMembers.value = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load family members');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFamilyMember() async {
    if (nameController.text.isEmpty || relationshipController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }
    
    try {
      isLoading.value = true;
      final response = await _apiService.addFamilyMember({
        'name': nameController.text.trim(),
        'relationship': relationshipController.text.trim(),
        'phone': phoneController.text.trim(),
      });
      
      if (response != null && response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Family member added successfully');
        await loadFamilyMembers();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add family member');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    relationshipController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
