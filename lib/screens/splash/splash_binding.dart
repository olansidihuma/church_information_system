import 'package:get/get.dart';
import 'package:church_information_system/controllers/splash_controller.dart';

/// Splash Screen Binding
/// 
/// Initializes dependencies for the splash screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
