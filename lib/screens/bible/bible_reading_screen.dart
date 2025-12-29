import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:church_information_system/models/bible_models.dart';

class BibleReadingScreen extends GetView<BibleController> {
  const BibleReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bookId = args?['bookId'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baca Alkitab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () => _showMarkProgressDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        final progress = controller.currentProgress.value;
        final currentBookId = bookId ?? progress?.bookId ?? 'gen';
        final book = controller.getBookById(currentBookId);
        
        if (book == null) {
          return const Center(child: Text('Kitab tidak ditemukan'));
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Header
              Card(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${book.testament == 'old' ? 'Perjanjian Lama' : 'Perjanjian Baru'} • ${book.chapters} Pasal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Current Position
              if (progress != null && progress.bookId == currentBookId)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text('Posisi Terakhir: Pasal ${progress.chapter}, Ayat ${progress.verse}'),
                    trailing: ElevatedButton(
                      onPressed: () => _navigateToChapter(context, book, progress.chapter),
                      child: const Text('Lanjut'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Chapters List
              Text(
                'Daftar Pasal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: book.chapters,
                itemBuilder: (context, index) {
                  final chapter = index + 1;
                  final isCurrentChapter = progress?.bookId == currentBookId && 
                                         progress?.chapter == chapter;
                  
                  return Card(
                    color: isCurrentChapter 
                        ? Theme.of(context).primaryColor 
                        : null,
                    child: InkWell(
                      onTap: () => _navigateToChapter(context, book, chapter),
                      child: Center(
                        child: Text(
                          '$chapter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrentChapter ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void _navigateToChapter(BuildContext context, BibleBook book, int chapter) {
    final verses = book.versesPerChapter[chapter - 1];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${book.name} Pasal $chapter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah ayat: $verses'),
            const SizedBox(height: 16),
            const Text(
              'Catatan: Fitur pembacaan penuh Alkitab memerlukan data teks lengkap. '
              'Saat ini Anda dapat menandai progress bacaan Anda.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _updateProgress(book.id, chapter, 1);
            },
            child: const Text('Tandai Sebagai Dibaca'),
          ),
        ],
      ),
    );
  }

  void _updateProgress(String bookId, int chapter, int verse) {
    final progress = ReadingProgress(
      bookId: bookId,
      chapter: chapter,
      verse: verse,
      lastRead: DateTime.now(),
      versesRead: (controller.currentProgress.value?.versesRead ?? 0) + 1,
      chaptersCompleted: controller.currentProgress.value?.chaptersCompleted ?? 0,
    );
    
    controller.updateProgress(progress);
  }

  void _showMarkProgressDialog(BuildContext context) {
    final versesController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tandai Progress Hari Ini'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: versesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Ayat yang Dibaca',
                helperText: 'Masukkan jumlah ayat yang sudah dibaca hari ini',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final count = int.tryParse(versesController.text) ?? 0;
              if (count > 0) {
                controller.markVersesRead(count);
                Get.back();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
