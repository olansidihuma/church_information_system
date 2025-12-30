import 'package:get/get.dart';
import 'package:church_information_system/models/news_model.dart';

/// Information Controller
/// 
/// Handles information page logic including video gallery
class InformationController extends GetxController {
  final videos = <VideoModel>[].obs;
  final news = <NewsModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'all'.obs;
  
  final categories = [
    'all',
    'worship',
    'testimony',
    'teaching',
    'events',
  ];

  @override
  void onInit() {
    super.onInit();
    loadVideos();
    loadNews();
  }

  /// Load videos from API or local storage
  Future<void> loadVideos() async {
    try {
      isLoading.value = true;
      // For now, use mock data. In production, fetch from API
      videos.value = _getMockVideos();
    } catch (e) {
      // Fail silently
    } finally {
      isLoading.value = false;
    }
  }

  /// Load news from API
  Future<void> loadNews() async {
    try {
      // For now, use mock data. In production, fetch from API
      news.value = _getMockNews();
    } catch (e) {
      // Fail silently
    }
  }

  /// Filter videos by category
  List<VideoModel> get filteredVideos {
    if (selectedCategory.value == 'all') {
      return videos;
    }
    return videos.where((v) => v.category == selectedCategory.value).toList();
  }

  /// Set selected category
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  /// Mock videos (replace with API call in production)
  List<VideoModel> _getMockVideos() {
    return [
      VideoModel(
        id: '1',
        title: 'Kebaktian Minggu - Kasih yang Sejati',
        description: 'Khotbah tentang kasih Allah yang sempurna bagi kita',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '', // Using gradient placeholder
        category: 'worship',
        uploadDate: DateTime.now().subtract(const Duration(days: 7)),
        duration: 2400, // 40 minutes
      ),
      VideoModel(
        id: '2',
        title: 'Kesaksian: Mujizat Kesembuhan',
        description: 'Kesaksian nyata tentang kuasa Tuhan dalam kehidupan',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '', // Using gradient placeholder
        category: 'testimony',
        uploadDate: DateTime.now().subtract(const Duration(days: 5)),
        duration: 900, // 15 minutes
      ),
      VideoModel(
        id: '3',
        title: 'Pengajaran: Hidup dalam Iman',
        description: 'Belajar tentang kehidupan yang beriman kepada Tuhan',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '', // Using gradient placeholder
        category: 'teaching',
        uploadDate: DateTime.now().subtract(const Duration(days: 3)),
        duration: 1800, // 30 minutes
      ),
      VideoModel(
        id: '4',
        title: 'Retret Pemuda 2024',
        description: 'Highlight dari retret pemuda tahun ini',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '', // Using gradient placeholder
        category: 'events',
        uploadDate: DateTime.now().subtract(const Duration(days: 1)),
        duration: 600, // 10 minutes
      ),
    ];
  }

  /// Mock news
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
    ];
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadVideos(),
      loadNews(),
    ]);
  }
}
