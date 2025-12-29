import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/bible_controller.dart';
import 'package:church_information_system/models/bible_models.dart';

class BibleScheduleScreen extends GetView<BibleController> {
  const BibleScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Membaca'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        final schedules = controller.schedules;
        
        if (schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Belum ada jadwal membaca'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddScheduleDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Jadwal'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  schedule.isActive ? Icons.alarm_on : Icons.alarm_off,
                  color: schedule.isActive ? Colors.green : Colors.grey,
                ),
                title: Text(schedule.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Waktu: ${schedule.time}'),
                    Text(
                      schedule.isEveryday 
                          ? 'Setiap hari' 
                          : 'Hari: ${_formatDays(schedule.daysOfWeek)}',
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: schedule.isActive,
                      onChanged: (value) {
                        controller.toggleScheduleActive(schedule.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, schedule),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDays(List<int> days) {
    if (days.isEmpty) return 'Setiap hari';
    
    final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days.map((d) => dayNames[d - 1]).join(', ');
  }

  void _showAddScheduleDialog(BuildContext context) {
    final nameController = TextEditingController();
    final timeController = TextEditingController(text: '06:00');
    final selectedDays = <int>[].obs;
    final isEveryday = true.obs;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Jadwal Membaca'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Jadwal',
                  hintText: 'Contoh: Bacaan Pagi',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Waktu (HH:mm)',
                  hintText: '06:00',
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                title: const Text('Setiap Hari'),
                value: isEveryday.value,
                onChanged: (value) {
                  isEveryday.value = value ?? true;
                  if (value == true) selectedDays.clear();
                },
              )),
              Obx(() {
                if (!isEveryday.value) {
                  return Column(
                    children: [
                      const Text('Pilih Hari:'),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (int i = 1; i <= 7; i++)
                            FilterChip(
                              label: Text(_getDayName(i)),
                              selected: selectedDays.contains(i),
                              onSelected: (selected) {
                                if (selected) {
                                  selectedDays.add(i);
                                } else {
                                  selectedDays.remove(i);
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                Get.snackbar('Error', 'Nama jadwal tidak boleh kosong');
                return;
              }
              
              final schedule = controller._bibleService.createSchedule(
                name: nameController.text,
                daysOfWeek: isEveryday.value ? [] : selectedDays,
                time: timeController.text,
              );
              
              controller.addSchedule(schedule);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String _getDayName(int day) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[day - 1];
  }

  void _confirmDelete(BuildContext context, ReadingSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: Text('Apakah Anda yakin ingin menghapus jadwal "${schedule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteSchedule(schedule.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
