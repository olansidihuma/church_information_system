/// Bible Book Model
/// 
/// Represents a book in the Bible with chapters and verse counts
class BibleBook {
  final String id;
  final String name;
  final String testament; // 'old' or 'new'
  final int chapters;
  final List<int> versesPerChapter;

  BibleBook({
    required this.id,
    required this.name,
    required this.testament,
    required this.chapters,
    required this.versesPerChapter,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'testament': testament,
    'chapters': chapters,
    'versesPerChapter': versesPerChapter,
  };

  factory BibleBook.fromJson(Map<String, dynamic> json) => BibleBook(
    id: json['id'],
    name: json['name'],
    testament: json['testament'],
    chapters: json['chapters'],
    versesPerChapter: List<int>.from(json['versesPerChapter']),
  );
}

/// Reading Progress Model
/// 
/// Tracks user's Bible reading progress
class ReadingProgress {
  final String bookId;
  final int chapter;
  final int verse;
  final DateTime lastRead;
  final int versesRead;
  final int chaptersCompleted;

  ReadingProgress({
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.lastRead,
    this.versesRead = 0,
    this.chaptersCompleted = 0,
  });

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'chapter': chapter,
    'verse': verse,
    'lastRead': lastRead.toIso8601String(),
    'versesRead': versesRead,
    'chaptersCompleted': chaptersCompleted,
  };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) => ReadingProgress(
    bookId: json['bookId'],
    chapter: json['chapter'],
    verse: json['verse'],
    lastRead: DateTime.parse(json['lastRead']),
    versesRead: json['versesRead'] ?? 0,
    chaptersCompleted: json['chaptersCompleted'] ?? 0,
  );

  ReadingProgress copyWith({
    String? bookId,
    int? chapter,
    int? verse,
    DateTime? lastRead,
    int? versesRead,
    int? chaptersCompleted,
  }) {
    return ReadingProgress(
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      lastRead: lastRead ?? this.lastRead,
      versesRead: versesRead ?? this.versesRead,
      chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
    );
  }
}

/// Reading Schedule Model
/// 
/// Represents a daily reading schedule
class ReadingSchedule {
  final String id;
  final String name;
  final List<int> daysOfWeek; // 1-7 (Monday-Sunday), empty for everyday
  final String time; // HH:mm format
  final bool isActive;
  final bool notificationEnabled;

  ReadingSchedule({
    required this.id,
    required this.name,
    required this.daysOfWeek,
    required this.time,
    this.isActive = true,
    this.notificationEnabled = true,
  });

  bool get isEveryday => daysOfWeek.isEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'daysOfWeek': daysOfWeek,
    'time': time,
    'isActive': isActive,
    'notificationEnabled': notificationEnabled,
  };

  factory ReadingSchedule.fromJson(Map<String, dynamic> json) => ReadingSchedule(
    id: json['id'],
    name: json['name'],
    daysOfWeek: List<int>.from(json['daysOfWeek']),
    time: json['time'],
    isActive: json['isActive'] ?? true,
    notificationEnabled: json['notificationEnabled'] ?? true,
  );

  ReadingSchedule copyWith({
    String? id,
    String? name,
    List<int>? daysOfWeek,
    String? time,
    bool? isActive,
    bool? notificationEnabled,
  }) {
    return ReadingSchedule(
      id: id ?? this.id,
      name: name ?? this.name,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}

/// Daily Reading Record
/// 
/// Tracks completion of daily reading
class DailyReadingRecord {
  final DateTime date;
  final int chaptersRead;
  final int versesRead;
  final bool completed;

  DailyReadingRecord({
    required this.date,
    required this.chaptersRead,
    required this.versesRead,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'chaptersRead': chaptersRead,
    'versesRead': versesRead,
    'completed': completed,
  };

  factory DailyReadingRecord.fromJson(Map<String, dynamic> json) => DailyReadingRecord(
    date: DateTime.parse(json['date']),
    chaptersRead: json['chaptersRead'],
    versesRead: json['versesRead'],
    completed: json['completed'],
  );
}
