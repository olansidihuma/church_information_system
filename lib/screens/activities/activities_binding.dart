import 'package:get/get.dart';
import 'package:church_information_system/controllers/activities_controller.dart';

class ActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivitiesController());
  }
}
