import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:church_information_system/routes/app_routes.dart';

/// Bible Main Screen
/// 
/// Main screen for offline Bible reading feature
class BibleScreen extends GetView<BibleController> {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alkitab Offline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () => Get.toNamed(AppRoutes.bibleSchedule),
            tooltip: 'Jadwal Membaca',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Progress Card
              _buildTodayProgressCard(context),
              const SizedBox(height: 24),
              
              // Current Reading Position
              _buildCurrentPositionCard(context),
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(context),
              const SizedBox(height: 24),
              
              // Bible Books List
              Text(
                'Daftar Kitab',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              
              // Testament Filter
              _buildTestamentFilter(context),
              const SizedBox(height: 16),
              
              // Books Grid
              Obx(() => _buildBooksGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgressCard(BuildContext context) {
    return Obx(() {
      final record = controller.todayRecord.value;
      final hasRead = record != null && record.versesRead > 0;
      
      return Card(
        color: hasRead ? Colors.green.shade50 : Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasRead ? Icons.check_circle : Icons.menu_book,
                    color: hasRead ? Colors.green : Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasRead ? 'Anda Sudah Membaca Hari Ini!' : 'Bacaan Hari Ini',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasRead
                              ? '${record.versesRead} ayat dibaca'
                              : 'Belum ada bacaan hari ini',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCurrentPositionCard(BuildContext context) {
    return Obx(() {
      final progress = controller.currentProgress.value;
      
      if (progress == null) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.auto_stories, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'Belum Ada Progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text('Mulai membaca Alkitab untuk melacak progress Anda'),
              ],
            ),
          ),
        );
      }
      
      final book = controller.getBookById(progress.bookId);
      
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posisi Bacaan Saat Ini',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book?.name ?? 'Unknown',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pasal ${progress.chapter}, Ayat ${progress.verse}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.bibleReading),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Lanjut'),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Ayat Dibaca',
                    '${progress.versesRead}',
                    Icons.article,
                  ),
                  _buildStatItem(
                    context,
                    'Pasal Selesai',
                    '${progress.chaptersCompleted}',
                    Icons.book,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.bibleReading),
            icon: const Icon(Icons.auto_stories),
            label: const Text('Baca Alkitab'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.bibleProgress),
            icon: const Icon(Icons.trending_up),
            label: const Text('Lihat Progress'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestamentFilter(BuildContext context) {
    return Obx(() => SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'all',
          label: Text('Semua'),
          icon: Icon(Icons.library_books),
        ),
        ButtonSegment(
          value: 'old',
          label: Text('PL'),
          icon: Icon(Icons.book),
        ),
        ButtonSegment(
          value: 'new',
          label: Text('PB'),
          icon: Icon(Icons.menu_book),
        ),
      ],
      selected: {controller.selectedTestament.value},
      onSelectionChanged: (Set<String> newSelection) {
        controller.changeTestament(newSelection.first);
      },
    ));
  }

  Widget _buildBooksGrid(BuildContext context) {
    final books = controller.filteredBooks;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          child: InkWell(
            onTap: () {
              Get.toNamed(
                AppRoutes.bibleReading,
                arguments: {'bookId': book.id},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    book.testament == 'old' ? Icons.book : Icons.menu_book,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${book.chapters} Pasal',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
