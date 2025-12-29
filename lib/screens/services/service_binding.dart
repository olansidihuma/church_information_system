import 'package:get/get.dart';
import 'package:church_information_system/controllers/service_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController());
  }
}
