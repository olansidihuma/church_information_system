import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/activities_controller.dart';

class ActivitiesScreen extends GetView<ActivitiesController> {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Church Activities')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            final activity = controller.activities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(activity['title'] ?? ''),
                subtitle: Text(activity['start_time'] ?? ''),
              ),
            );
          },
        );
      }),
    );
  }
}
