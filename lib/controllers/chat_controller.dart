import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';
import 'package:church_information_system/services/storage_service.dart';

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();
  
  final messageController = TextEditingController();
  final messages = <Map<String, dynamic>>[].obs;
  final userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = _storageService.getUserId() ?? '';
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final response = await _apiService.getChatMessages();
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          messages.value = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    
    try {
      final response = await _apiService.sendChatMessage({
        'message': messageController.text.trim(),
      });
      
      if (response != null && response.statusCode == 201) {
        messageController.clear();
        await loadMessages();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
