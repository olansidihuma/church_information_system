import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/service_controller.dart';

class Prayer_requestScreen extends GetView<ServiceController> {
  const Prayer_requestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
