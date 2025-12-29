import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:church_information_system/services/bible_service.dart';

class BibleBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize Bible Service if not already initialized
    if (!Get.isRegistered<BibleService>()) {
      Get.putAsync(() => BibleService().init());
    }
    
    Get.lazyPut(() => BibleController());
  }
}
