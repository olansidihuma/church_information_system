import 'package:get/get.dart';

class ServiceController extends GetxController {
  final isLoading = false.obs;
  
  Future<void> submitRequest() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      Get.snackbar('Success', 'Request submitted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit request');
    } finally {
      isLoading.value = false;
    }
  }
}
