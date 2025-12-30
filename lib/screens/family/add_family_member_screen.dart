import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/family_controller.dart';

class AddFamilyMemberScreen extends GetView<FamilyController> {
  const AddFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Family Member')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.addFamilyMember,
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Add Member'),
            )),
          ],
        ),
      ),
    );
  }
}
