import 'package:get/get.dart';
import 'package:church_information_system/models/bible_models.dart';
import 'package:church_information_system/services/bible_service.dart';

/// Bible Controller
/// 
/// Manages Bible reading functionality and state
class BibleController extends GetxController {
  final BibleService _bibleService = Get.find<BibleService>();
  
  final books = <BibleBook>[].obs;
  final currentProgress = Rxn<ReadingProgress>();
  final schedules = <ReadingSchedule>[].obs;
  final todayRecord = Rxn<DailyReadingRecord>();
  
  final isLoading = false.obs;
  final selectedTestament = 'all'.obs; // 'all', 'old', 'new'

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load all Bible data
  void loadData() {
    isLoading.value = true;
    
    books.value = _bibleService.getAllBooks();
    currentProgress.value = _bibleService.getCurrentProgress();
    schedules.value = _bibleService.getSchedules();
    todayRecord.value = _bibleService.getTodayRecord();
    
    isLoading.value = false;
  }

  /// Get filtered books based on testament selection
  List<BibleBook> get filteredBooks {
    if (selectedTestament.value == 'old') {
      return books.where((b) => b.testament == 'old').toList();
    } else if (selectedTestament.value == 'new') {
      return books.where((b) => b.testament == 'new').toList();
    }
    return books;
  }

  /// Update reading progress
  Future<void> updateProgress(ReadingProgress progress) async {
    isLoading.value = true;
    final success = await _bibleService.saveProgress(progress);
    
    if (success) {
      currentProgress.value = progress;
      todayRecord.value = _bibleService.getTodayRecord();
      Get.snackbar('Sukses', 'Progress membaca berhasil disimpan');
    } else {
      Get.snackbar('Error', 'Gagal menyimpan progress');
    }
    
    isLoading.value = false;
  }

  /// Mark verses as read
  Future<void> markVersesRead(int count) async {
    final success = await _bibleService.markVersesRead(count);
    
    if (success) {
      currentProgress.value = _bibleService.getCurrentProgress();
      todayRecord.value = _bibleService.getTodayRecord();
      Get.snackbar('Sukses', '$count ayat telah ditandai sebagai dibaca');
    }
  }

  /// Mark chapter as completed
  Future<void> markChapterCompleted() async {
    final success = await _bibleService.markChapterCompleted();
    
    if (success) {
      currentProgress.value = _bibleService.getCurrentProgress();
      todayRecord.value = _bibleService.getTodayRecord();
      Get.snackbar('Sukses', 'Pasal telah ditandai selesai');
    }
  }

  /// Add reading schedule
  Future<void> addSchedule(ReadingSchedule schedule) async {
    final success = await _bibleService.addSchedule(schedule);
    
    if (success) {
      schedules.value = _bibleService.getSchedules();
      Get.back();
      Get.snackbar('Sukses', 'Jadwal membaca berhasil ditambahkan');
    } else {
      Get.snackbar('Error', 'Gagal menambahkan jadwal');
    }
  }

  /// Update reading schedule
  Future<void> updateSchedule(ReadingSchedule schedule) async {
    final success = await _bibleService.updateSchedule(schedule);
    
    if (success) {
      schedules.value = _bibleService.getSchedules();
      Get.back();
      Get.snackbar('Sukses', 'Jadwal membaca berhasil diperbarui');
    } else {
      Get.snackbar('Error', 'Gagal memperbarui jadwal');
    }
  }

  /// Delete reading schedule
  Future<void> deleteSchedule(String scheduleId) async {
    final success = await _bibleService.deleteSchedule(scheduleId);
    
    if (success) {
      schedules.value = _bibleService.getSchedules();
      Get.snackbar('Sukses', 'Jadwal membaca berhasil dihapus');
    } else {
      Get.snackbar('Error', 'Gagal menghapus jadwal');
    }
  }

  /// Toggle schedule active status
  Future<void> toggleScheduleActive(String scheduleId) async {
    final schedule = schedules.firstWhere((s) => s.id == scheduleId);
    final updated = schedule.copyWith(isActive: !schedule.isActive);
    await updateSchedule(updated);
  }

  /// Get book by ID
  BibleBook? getBookById(String bookId) {
    return _bibleService.getBookById(bookId);
  }
  
  /// Load chapter content
  Future<BibleChapter?> loadChapter(String bookId, int chapterNumber) async {
    final bookName = _bibleService.getBookNameForXml(bookId);
    if (bookName == null) return null;
    
    return await _bibleService.loadChapter(bookName, chapterNumber);
  }

  /// Change testament filter
  void changeTestament(String testament) {
    selectedTestament.value = testament;
  }
}
