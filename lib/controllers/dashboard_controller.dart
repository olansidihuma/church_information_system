import 'package:get/get.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/routes/app_routes.dart';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final userName = ''.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadData();
  }

  void loadUserData() {
    userName.value = _storageService.getUserName() ?? 'User';
    userEmail.value = _storageService.getUserEmail() ?? '';
  }

  Future<void> loadData() async {
    // Load dashboard data
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> logout() async {
    await _storageService.logout();
    Get.offAllNamed(AppRoutes.home);
    Get.snackbar('Success', 'Logged out successfully');
  }
}
