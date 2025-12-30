import 'package:get/get.dart';
import 'package:church_information_system/controllers/information_controller.dart';

/// Information Binding
/// 
/// Binds the InformationController to the Information page
class InformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationController>(() => InformationController());
  }
}
