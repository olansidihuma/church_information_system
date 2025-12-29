import 'package:get/get.dart';
import 'package:church_information_system/services/storage_service.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final userName = ''.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    userName.value = _storageService.getUserName() ?? 'User';
    userEmail.value = _storageService.getUserEmail() ?? '';
  }
}
