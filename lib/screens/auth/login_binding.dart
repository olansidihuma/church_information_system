import 'package:get/get.dart';
import 'package:church_information_system/controllers/login_controller.dart';

/// Login Screen Binding
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
