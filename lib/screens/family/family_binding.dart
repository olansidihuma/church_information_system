import 'package:get/get.dart';
import 'package:church_information_system/controllers/family_controller.dart';

class FamilyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FamilyController());
  }
}
