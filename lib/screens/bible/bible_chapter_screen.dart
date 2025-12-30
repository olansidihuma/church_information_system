import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:church_information_system/models/bible_models.dart';

class BibleChapterScreen extends GetView<BibleController> {
  const BibleChapterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final bookId = args['bookId'] as String;
    final bookName = args['bookName'] as String;
    final chapterNumber = args['chapterNumber'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('$bookName Pasal $chapterNumber'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () => _markAsRead(bookId, chapterNumber),
            tooltip: 'Tandai Sebagai Dibaca',
          ),
        ],
      ),
      body: FutureBuilder<BibleChapter?>(
        future: controller.loadChapter(bookId, chapterNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat ayat...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          final chapter = snapshot.data;
          if (chapter == null || chapter.verses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Pasal tidak ditemukan'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Chapter Info Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).primaryColor.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$bookName Pasal $chapterNumber',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.verses.length} ayat',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Verses List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chapter.verses.length,
                  itemBuilder: (context, index) {
                    final verse = chapter.verses[index];
                    return _buildVerseCard(verse, context);
                  },
                ),
              ),
              
              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: chapterNumber > 1
                            ? () => _navigateToPreviousChapter(bookId, bookName, chapterNumber)
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Pasal Sebelumnya'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToNextChapter(bookId, bookName, chapterNumber),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Pasal Berikutnya'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerseCard(BibleVerse verse, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verse number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${verse.number}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Verse text
          Expanded(
            child: SelectableText(
              verse.text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _markAsRead(String bookId, int chapterNumber) {
    final currentProgress = controller.currentProgress.value;
    
    // Only increment chaptersCompleted if this is a new chapter
    final isNewChapter = currentProgress == null || 
                         currentProgress.bookId != bookId || 
                         currentProgress.chapter != chapterNumber;
    
    final progress = ReadingProgress(
      bookId: bookId,
      chapter: chapterNumber,
      verse: 1,
      lastRead: DateTime.now(),
      versesRead: currentProgress?.versesRead ?? 0,
      chaptersCompleted: isNewChapter 
          ? (currentProgress?.chaptersCompleted ?? 0) + 1
          : (currentProgress?.chaptersCompleted ?? 0),
    );
    
    controller.updateProgress(progress);
  }

  void _navigateToPreviousChapter(String bookId, String bookName, int currentChapter) {
    Get.off(
      () => const BibleChapterScreen(),
      arguments: {
        'bookId': bookId,
        'bookName': bookName,
        'chapterNumber': currentChapter - 1,
      },
    );
  }

  void _navigateToNextChapter(String bookId, String bookName, int currentChapter) {
    final book = controller.getBookById(bookId);
    if (book != null && currentChapter < book.chapters) {
      Get.off(
        () => const BibleChapterScreen(),
        arguments: {
          'bookId': bookId,
          'bookName': bookName,
          'chapterNumber': currentChapter + 1,
        },
      );
    } else {
      Get.snackbar(
        'Info',
        'Ini adalah pasal terakhir dari kitab $bookName',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
