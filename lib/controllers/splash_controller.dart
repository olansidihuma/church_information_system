import 'package:get/get.dart';
import 'package:church_information_system/routes/app_routes.dart';
import 'package:church_information_system/services/storage_service.dart';

/// Splash Controller
/// 
/// Handles splash screen logic and navigation
class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Initialize the application
  Future<void> _initializeApp() async {
    // Wait for minimum splash duration (for better UX)
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is logged in
    if (_storageService.isLoggedIn()) {
      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      // Navigate to home (public page)
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
