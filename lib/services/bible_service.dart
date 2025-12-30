import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:church_information_system/models/bible_models.dart';
import 'package:church_information_system/services/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;

/// Bible Service
/// 
/// Manages offline Bible reading data, progress tracking, and schedules
class BibleService extends GetxService {
  late SharedPreferences _prefs;
  
  // Storage Keys
  static const String keyCurrentProgress = 'bible_current_progress';
  static const String keyReadingSchedules = 'bible_reading_schedules';
  static const String keyDailyRecords = 'bible_daily_records';
  static const String keyTodayRecord = 'bible_today_record';
  
  /// Initialize the Bible service
  Future<BibleService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
  
  // ============ Bible Books Data ============
  
  /// Get all Bible books (Indonesian names)
  List<BibleBook> getAllBooks() {
    return _indonesianBibleBooks;
  }
  
  /// Get Old Testament books
  List<BibleBook> getOldTestamentBooks() {
    return _indonesianBibleBooks.where((b) => b.testament == 'old').toList();
  }
  
  /// Get New Testament books
  List<BibleBook> getNewTestamentBooks() {
    return _indonesianBibleBooks.where((b) => b.testament == 'new').toList();
  }
  
  /// Get book by ID
  BibleBook? getBookById(String bookId) {
    try {
      return _indonesianBibleBooks.firstWhere((b) => b.id == bookId);
    } catch (e) {
      return null;
    }
  }
  
  // ============ Bible Content from XML ============
  
  /// Load chapter content from alkitab.xml
  Future<BibleChapter?> loadChapter(String bookName, int chapterNumber) async {
    try {
      // Load the XML file from assets
      final xmlString = await rootBundle.loadString('assets/alkitab.xml');
      final document = xml.XmlDocument.parse(xmlString);
      
      // Find the book
      final bookElements = document.findAllElements('BIBLEBOOK')
          .where((element) => element.getAttribute('bname') == bookName);
      
      if (bookElements.isEmpty) {
        print('Book not found: $bookName');
        return null;
      }
      
      final bookElement = bookElements.first;
      
      // Find the chapter
      final chapterElements = bookElement.findAllElements('CHAPTER')
          .where((element) => element.getAttribute('cnumber') == chapterNumber.toString());
      
      if (chapterElements.isEmpty) {
        print('Chapter not found: $bookName chapter $chapterNumber');
        return null;
      }
      
      final chapterElement = chapterElements.first;
      
      // Extract verses
      final verses = <BibleVerse>[];
      for (final verseElement in chapterElement.findAllElements('VERS')) {
        final verseNumber = int.parse(verseElement.getAttribute('vnumber') ?? '0');
        final verseText = verseElement.innerText.trim();
        verses.add(BibleVerse(number: verseNumber, text: verseText));
      }
      
      return BibleChapter(number: chapterNumber, verses: verses);
    } catch (e) {
      print('Error loading chapter: $e');
      return null;
    }
  }
  
  /// Get book name from book ID for XML lookup
  String? getBookNameForXml(String bookId) {
    final book = getBookById(bookId);
    return book?.name;
  }
  
  // ============ Reading Progress ============
  
  /// Get current reading progress
  ReadingProgress? getCurrentProgress() {
    final data = _prefs.getString(keyCurrentProgress);
    if (data == null) return null;
    return ReadingProgress.fromJson(json.decode(data));
  }
  
  /// Save reading progress
  Future<bool> saveProgress(ReadingProgress progress) async {
    final data = json.encode(progress.toJson());
    final success = await _prefs.setString(keyCurrentProgress, data);
    
    // Update today's record
    if (success) {
      await _updateTodayRecord(progress);
    }
    
    return success;
  }
  
  /// Update reading progress
  Future<bool> updateProgress({
    String? bookId,
    int? chapter,
    int? verse,
    int? versesRead,
    int? chaptersCompleted,
  }) async {
    final current = getCurrentProgress() ?? ReadingProgress(
      bookId: 'gen',
      chapter: 1,
      verse: 1,
      lastRead: DateTime.now(),
    );
    
    final updated = current.copyWith(
      bookId: bookId,
      chapter: chapter,
      verse: verse,
      lastRead: DateTime.now(),
      versesRead: versesRead ?? current.versesRead,
      chaptersCompleted: chaptersCompleted ?? current.chaptersCompleted,
    );
    
    return await saveProgress(updated);
  }
  
  /// Mark verses as read for today
  Future<bool> markVersesRead(int count) async {
    final current = getCurrentProgress();
    if (current == null) return false;
    
    return await updateProgress(
      versesRead: current.versesRead + count,
    );
  }
  
  /// Mark chapter as completed
  Future<bool> markChapterCompleted() async {
    final current = getCurrentProgress();
    if (current == null) return false;
    
    return await updateProgress(
      chaptersCompleted: current.chaptersCompleted + 1,
    );
  }
  
  // ============ Reading Schedules ============
  
  /// Get all reading schedules
  List<ReadingSchedule> getSchedules() {
    final data = _prefs.getString(keyReadingSchedules);
    if (data == null) return [];
    
    final List<dynamic> list = json.decode(data);
    return list.map((item) => ReadingSchedule.fromJson(item)).toList();
  }
  
  /// Save schedules
  Future<bool> _saveSchedules(List<ReadingSchedule> schedules) async {
    final data = json.encode(schedules.map((s) => s.toJson()).toList());
    return await _prefs.setString(keyReadingSchedules, data);
  }
  
  /// Add reading schedule
  Future<bool> addSchedule(ReadingSchedule schedule) async {
    final schedules = getSchedules();
    schedules.add(schedule);
    
    final success = await _saveSchedules(schedules);
    
    // Schedule notification if enabled
    if (success && schedule.notificationEnabled && schedule.isActive) {
      await _scheduleNotification(schedule);
    }
    
    return success;
  }
  
  /// Update reading schedule
  Future<bool> updateSchedule(ReadingSchedule schedule) async {
    final schedules = getSchedules();
    final index = schedules.indexWhere((s) => s.id == schedule.id);
    
    if (index == -1) return false;
    
    schedules[index] = schedule;
    final success = await _saveSchedules(schedules);
    
    // Update notification
    if (success) {
      final notificationService = Get.find<NotificationService>();
      await notificationService.cancelNotification(schedule.id.hashCode);
      
      if (schedule.notificationEnabled && schedule.isActive) {
        await _scheduleNotification(schedule);
      }
    }
    
    return success;
  }
  
  /// Delete reading schedule
  Future<bool> deleteSchedule(String scheduleId) async {
    final schedules = getSchedules();
    schedules.removeWhere((s) => s.id == scheduleId);
    
    // Cancel notification
    final notificationService = Get.find<NotificationService>();
    await notificationService.cancelNotification(scheduleId.hashCode);
    
    return await _saveSchedules(schedules);
  }
  
  /// Create a new schedule
  ReadingSchedule createSchedule({
    required String name,
    required List<int> daysOfWeek,
    required String time,
    bool notificationEnabled = true,
  }) {
    return ReadingSchedule(
      id: const Uuid().v4(),
      name: name,
      daysOfWeek: daysOfWeek,
      time: time,
      notificationEnabled: notificationEnabled,
    );
  }
  
  // ============ Daily Records ============
  
  /// Get today's reading record
  DailyReadingRecord? getTodayRecord() {
    final data = _prefs.getString(keyTodayRecord);
    if (data == null) return null;
    
    final record = DailyReadingRecord.fromJson(json.decode(data));
    
    // Check if it's still today
    final now = DateTime.now();
    if (record.date.year == now.year &&
        record.date.month == now.month &&
        record.date.day == now.day) {
      return record;
    }
    
    return null;
  }
  
  /// Update today's record
  Future<void> _updateTodayRecord(ReadingProgress progress) async {
    final today = DateTime.now();
    final existing = getTodayRecord();
    
    final record = DailyReadingRecord(
      date: today,
      chaptersRead: existing?.chaptersRead ?? 0,
      versesRead: progress.versesRead,
      completed: progress.versesRead > 0,
    );
    
    final data = json.encode(record.toJson());
    await _prefs.setString(keyTodayRecord, data);
  }
  
  /// Get all reading records
  List<DailyReadingRecord> getAllRecords() {
    final data = _prefs.getString(keyDailyRecords);
    if (data == null) return [];
    
    final List<dynamic> list = json.decode(data);
    return list.map((item) => DailyReadingRecord.fromJson(item)).toList();
  }
  
  // ============ Notifications ============
  
  /// Schedule notification for reading reminder
  Future<void> _scheduleNotification(ReadingSchedule schedule) async {
    final notificationService = Get.find<NotificationService>();
    final timeParts = schedule.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    // Calculate next notification time
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    await notificationService.scheduleNotification(
      id: schedule.id.hashCode,
      title: 'Waktu Membaca Alkitab',
      body: 'Waktunya untuk membaca Alkitab: ${schedule.name}',
      scheduledTime: scheduledTime,
      payload: 'bible_reading',
    );
  }
  
  // ============ Indonesian Bible Books Data ============
  
  static final List<BibleBook> _indonesianBibleBooks = [
    // Old Testament - Perjanjian Lama
    BibleBook(id: 'gen', name: 'Kejadian', testament: 'old', chapters: 50, versesPerChapter: [31,25,24,26,32,22,24,22,29,32,32,20,18,24,21,16,27,33,38,18,34,24,20,67,34,35,46,22,35,43,55,32,20,31,29,43,36,30,23,23,57,38,34,34,28,34,31,22,33,26]),
    BibleBook(id: 'exo', name: 'Keluaran', testament: 'old', chapters: 40, versesPerChapter: [22,25,22,31,23,30,25,32,35,29,10,51,22,31,27,36,16,27,25,26,36,31,33,18,40,37,21,43,46,38,18,35,23,35,35,38,29,31,43,38]),
    BibleBook(id: 'lev', name: 'Imamat', testament: 'old', chapters: 27, versesPerChapter: [17,16,17,35,19,30,38,36,24,20,47,8,59,57,33,34,16,30,37,27,24,33,44,23,55,46,34]),
    BibleBook(id: 'num', name: 'Bilangan', testament: 'old', chapters: 36, versesPerChapter: [54,34,51,49,31,27,89,26,23,36,35,16,33,45,41,50,13,32,22,29,35,41,30,25,18,65,23,31,40,16,54,42,56,29,34,13]),
    BibleBook(id: 'deu', name: 'Ulangan', testament: 'old', chapters: 34, versesPerChapter: [46,37,29,49,33,25,26,20,29,22,32,32,18,29,23,22,20,22,21,20,23,30,25,22,19,19,26,68,29,20,30,52,29,12]),
    BibleBook(id: 'jos', name: 'Yosua', testament: 'old', chapters: 24, versesPerChapter: [18,24,17,24,15,27,26,35,27,43,23,24,33,15,63,10,18,28,51,9,45,34,16,33]),
    BibleBook(id: 'jdg', name: 'Hakim-hakim', testament: 'old', chapters: 21, versesPerChapter: [36,23,31,24,31,40,25,35,57,18,40,15,25,20,20,31,13,31,30,48,25]),
    BibleBook(id: 'rut', name: 'Rut', testament: 'old', chapters: 4, versesPerChapter: [22,23,18,22]),
    BibleBook(id: '1sa', name: '1 Samuel', testament: 'old', chapters: 31, versesPerChapter: [28,36,21,22,12,21,17,22,27,27,15,25,23,52,35,23,58,30,24,42,15,23,29,22,44,25,12,25,11,31,13]),
    BibleBook(id: '2sa', name: '2 Samuel', testament: 'old', chapters: 24, versesPerChapter: [27,32,39,12,25,23,29,18,13,19,27,31,39,33,37,23,29,33,43,26,22,51,39,25]),
    BibleBook(id: '1ki', name: '1 Raja-raja', testament: 'old', chapters: 22, versesPerChapter: [53,46,28,34,18,38,51,66,28,29,43,33,34,31,34,34,24,46,21,43,29,53]),
    BibleBook(id: '2ki', name: '2 Raja-raja', testament: 'old', chapters: 25, versesPerChapter: [18,25,27,44,27,33,20,29,37,36,21,21,25,29,38,20,41,37,37,21,26,20,37,20,30]),
    BibleBook(id: 'psa', name: 'Mazmur', testament: 'old', chapters: 150, versesPerChapter: [6,12,8,8,12,10,17,9,20,18,7,8,6,7,5,11,15,50,14,9,13,31,6,10,22,12,14,9,11,12,24,11,22,22,28,12,40,22,13,17,13,11,5,26,17,11,9,14,20,23,19,9,6,7,23,13,11,11,17,12,8,12,11,10,13,20,7,35,36,5,24,20,28,23,10,12,20,72,13,19,16,8,18,12,13,17,7,18,52,17,16,15,5,23,11,13,12,9,9,5,8,28,22,35,45,48,43,13,31,7,10,10,9,8,18,19,2,29,176,7,8,9,4,8,5,6,5,6,8,8,3,18,3,3,21,26,9,8,24,13,10,7,12,15,21,10,20,14,9,6]),
    BibleBook(id: 'pro', name: 'Amsal', testament: 'old', chapters: 31, versesPerChapter: [33,22,35,27,23,35,27,36,18,32,31,28,25,35,33,33,28,24,29,30,31,29,35,34,28,28,27,28,27,33,31]),
    BibleBook(id: 'mat', name: 'Matius', testament: 'new', chapters: 28, versesPerChapter: [25,23,17,25,48,34,29,34,38,42,30,50,58,36,39,28,27,35,30,34,46,46,39,51,46,75,66,20]),
    BibleBook(id: 'mrk', name: 'Markus', testament: 'new', chapters: 16, versesPerChapter: [45,28,35,41,43,56,37,38,50,52,33,44,37,72,47,20]),
    BibleBook(id: 'luk', name: 'Lukas', testament: 'new', chapters: 24, versesPerChapter: [80,52,38,44,39,49,50,56,62,42,54,59,35,35,32,31,37,43,48,47,38,71,56,53]),
    BibleBook(id: 'jhn', name: 'Yohanes', testament: 'new', chapters: 21, versesPerChapter: [51,25,36,54,47,71,53,59,41,42,57,50,38,31,27,33,26,40,42,31,25]),
    BibleBook(id: 'act', name: 'Kisah Para Rasul', testament: 'new', chapters: 28, versesPerChapter: [26,47,26,37,42,15,60,40,43,48,30,25,52,28,41,40,34,28,41,38,40,30,35,27,27,32,44,31]),
    BibleBook(id: 'rom', name: 'Roma', testament: 'new', chapters: 16, versesPerChapter: [32,29,31,25,21,23,25,39,33,21,36,21,14,23,33,27]),
    BibleBook(id: '1co', name: '1 Korintus', testament: 'new', chapters: 16, versesPerChapter: [31,16,23,21,13,20,40,13,27,33,34,31,13,40,58,24]),
    BibleBook(id: '2co', name: '2 Korintus', testament: 'new', chapters: 13, versesPerChapter: [24,17,18,18,21,18,16,24,15,18,33,21,14]),
    BibleBook(id: 'gal', name: 'Galatia', testament: 'new', chapters: 6, versesPerChapter: [24,21,29,31,26,18]),
    BibleBook(id: 'eph', name: 'Efesus', testament: 'new', chapters: 6, versesPerChapter: [23,22,21,32,33,24]),
    BibleBook(id: 'php', name: 'Filipi', testament: 'new', chapters: 4, versesPerChapter: [30,30,21,23]),
    BibleBook(id: 'col', name: 'Kolose', testament: 'new', chapters: 4, versesPerChapter: [29,23,25,18]),
    BibleBook(id: '1th', name: '1 Tesalonika', testament: 'new', chapters: 5, versesPerChapter: [10,20,13,18,28]),
    BibleBook(id: '2th', name: '2 Tesalonika', testament: 'new', chapters: 3, versesPerChapter: [12,17,18]),
    BibleBook(id: '1ti', name: '1 Timotius', testament: 'new', chapters: 6, versesPerChapter: [20,15,16,16,25,21]),
    BibleBook(id: '2ti', name: '2 Timotius', testament: 'new', chapters: 4, versesPerChapter: [18,26,17,22]),
    BibleBook(id: 'tit', name: 'Titus', testament: 'new', chapters: 3, versesPerChapter: [16,15,15]),
    BibleBook(id: 'phm', name: 'Filemon', testament: 'new', chapters: 1, versesPerChapter: [25]),
    BibleBook(id: 'heb', name: 'Ibrani', testament: 'new', chapters: 13, versesPerChapter: [14,18,19,16,14,20,28,13,28,39,40,29,25]),
    BibleBook(id: 'jas', name: 'Yakobus', testament: 'new', chapters: 5, versesPerChapter: [27,26,18,17,20]),
    BibleBook(id: '1pe', name: '1 Petrus', testament: 'new', chapters: 5, versesPerChapter: [25,25,22,19,14]),
    BibleBook(id: '2pe', name: '2 Petrus', testament: 'new', chapters: 3, versesPerChapter: [21,22,18]),
    BibleBook(id: '1jn', name: '1 Yohanes', testament: 'new', chapters: 5, versesPerChapter: [10,29,24,21,21]),
    BibleBook(id: '2jn', name: '2 Yohanes', testament: 'new', chapters: 1, versesPerChapter: [13]),
    BibleBook(id: '3jn', name: '3 Yohanes', testament: 'new', chapters: 1, versesPerChapter: [14]),
    BibleBook(id: 'jud', name: 'Yudas', testament: 'new', chapters: 1, versesPerChapter: [25]),
    BibleBook(id: 'rev', name: 'Wahyu', testament: 'new', chapters: 22, versesPerChapter: [20,29,22,11,14,17,17,13,21,11,19,17,18,20,8,21,18,24,21,15,27,21]),
  ];
}
