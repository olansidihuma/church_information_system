import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';

class ActivitiesController extends GetxController {
  final ApiService _apiService = ApiService();
  final activities = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getActivities();
      
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          activities.value = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load activities');
    } finally {
      isLoading.value = false;
    }
  }
}
