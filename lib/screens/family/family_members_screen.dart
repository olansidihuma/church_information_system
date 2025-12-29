import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/family_controller.dart';
import 'package:church_information_system/routes/app_routes.dart';

class FamilyMembersScreen extends GetView<FamilyController> {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addFamilyMember),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.familyMembers.isEmpty) {
          return const Center(child: Text('No family members added'));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.familyMembers.length,
          itemBuilder: (context, index) {
            final member = controller.familyMembers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(member['name'] ?? ''),
                subtitle: Text(member['relationship'] ?? ''),
              ),
            );
          },
        );
      }),
    );
  }
}
