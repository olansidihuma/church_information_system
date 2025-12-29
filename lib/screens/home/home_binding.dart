import 'package:get/get.dart';
import 'package:church_information_system/controllers/home_controller.dart';

/// Home Screen Binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
