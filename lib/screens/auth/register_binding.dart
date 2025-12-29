import 'package:get/get.dart';
import 'package:church_information_system/controllers/register_controller.dart';

/// Register Screen Binding
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
