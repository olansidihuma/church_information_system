import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:intl/intl.dart';

class BibleProgressScreen extends GetView<BibleController> {
  const BibleProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Bacaan'),
      ),
      body: Obx(() {
        final progress = controller.currentProgress.value;
        final todayRecord = controller.todayRecord.value;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Progress
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Keseluruhan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (progress != null) ...[
                        _buildProgressItem(
                          context,
                          'Total Ayat Dibaca',
                          '${progress.versesRead}',
                          Icons.article,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildProgressItem(
                          context,
                          'Total Pasal Selesai',
                          '${progress.chaptersCompleted}',
                          Icons.book,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildProgressItem(
                          context,
                          'Terakhir Dibaca',
                          DateFormat('dd MMM yyyy, HH:mm').format(progress.lastRead),
                          Icons.schedule,
                          Colors.orange,
                        ),
                      ] else
                        const Text('Belum ada progress'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Today's Progress
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Hari Ini',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (todayRecord != null) ...[
                        Row(
                          children: [
                            Icon(
                              todayRecord.completed ? Icons.check_circle : Icons.circle_outlined,
                              color: todayRecord.completed ? Colors.green : Colors.grey,
                              size: 48,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todayRecord.completed 
                                        ? 'Sudah Membaca!' 
                                        : 'Belum Membaca',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text('${todayRecord.versesRead} ayat dibaca'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else
                        const Text('Belum ada bacaan hari ini'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Current Position
              if (progress != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posisi Bacaan Saat Ini',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.bookmark, size: 32),
                          title: Text(
                            controller.getBookById(progress.bookId)?.name ?? 'Unknown',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Pasal ${progress.chapter}, Ayat ${progress.verse}'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProgressItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
