import 'package:get/get.dart';
import 'package:church_information_system/services/api_service.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/models/news_model.dart';

/// Home Controller
/// 
/// Handles home screen logic and church activities display
class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();
  
  final activities = <Map<String, dynamic>>[].obs;
  final banners = <BannerModel>[].obs;
  final newsList = <NewsModel>[].obs;
  final isLoading = false.obs;
  final showWelcomePopup = false.obs;
  final currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkFirstLoad();
    loadActivities();
    loadBanners();
    loadNews();
  }

  /// Check if this is first load and show welcome popup
  Future<void> checkFirstLoad() async {
    final isFirstLoad = await _storageService.isFirstLoad();
    if (isFirstLoad) {
      showWelcomePopup.value = true;
      await _storageService.setFirstLoadComplete();
    }
  }

  /// Load church activities
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
      // Fail silently for public page
    } finally {
      isLoading.value = false;
    }
  }

  /// Load homepage banners
  Future<void> loadBanners() async {
    try {
      // For now, use mock data. In production, fetch from API
      banners.value = _getMockBanners();
    } catch (e) {
      // Fail silently
    }
  }

  /// Load news and announcements
  Future<void> loadNews() async {
    try {
      // For now, use mock data. In production, fetch from API
      newsList.value = _getMockNews();
    } catch (e) {
      // Fail silently
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadActivities(),
      loadBanners(),
      loadNews(),
    ]);
  }

  /// Mock banners (replace with API call in production)
  List<BannerModel> _getMockBanners() {
    return [
      BannerModel(
        id: '1',
        title: 'Selamat Datang di Gereja Kami',
        description: 'Bergabunglah dalam ibadah dan persekutuan',
        imageUrl: '', // Using gradient placeholder
      ),
      BannerModel(
        id: '2',
        title: 'Ibadah Minggu',
        description: 'Setiap Minggu pukul 08.00 & 17.00',
        imageUrl: '', // Using gradient placeholder
      ),
      BannerModel(
        id: '3',
        title: 'Persekutuan Doa',
        description: 'Setiap Rabu pukul 19.00',
        imageUrl: '', // Using gradient placeholder
      ),
    ];
  }

  /// Mock news (replace with API call in production)
  List<NewsModel> _getMockNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Kebaktian Natal 2024',
        content: 'Kebaktian Natal akan dilaksanakan pada tanggal 24 Desember 2024 pukul 19.00. Mari bersama-sama merayakan kelahiran Tuhan Yesus Kristus.',
        imageUrl: '', // Using gradient placeholder
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'announcement',
      ),
      NewsModel(
        id: '2',
        title: 'Retret Pemuda',
        content: 'Retret pemuda akan diadakan pada tanggal 5-7 Januari 2025 di Puncak. Pendaftaran dibuka hingga 28 Desember 2024.',
        imageUrl: '', // Using gradient placeholder
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'event',
      ),
      NewsModel(
        id: '3',
        title: 'Pelayanan Sosial',
        content: 'Gereja mengadakan pelayanan sosial untuk masyarakat sekitar. Mari berpartisipasi dalam membagikan kasih Kristus.',
        imageUrl: '', // Using gradient placeholder
        date: DateTime.now(),
        category: 'ministry',
      ),
    ];
  }

  void closeWelcomePopup() {
    showWelcomePopup.value = false;
  }
}
