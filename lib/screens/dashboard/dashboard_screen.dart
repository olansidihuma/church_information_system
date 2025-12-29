import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/dashboard_controller.dart';
import 'package:church_information_system/routes/app_routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(controller.userName.value),
              accountEmail: Text(controller.userEmail.value),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () => Get.toNamed(AppRoutes.calendar),
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: const Text('Family Members'),
              onTap: () => Get.toNamed(AppRoutes.familyMembers),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat with Admin'),
              onTap: () => Get.toNamed(AppRoutes.chat),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${controller.userName.value}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _ServiceCard(
                    icon: Icons.pray,
                    title: 'Prayer Request',
                    color: Colors.blue,
                    onTap: () => Get.toNamed(AppRoutes.prayerRequest),
                  ),
                  _ServiceCard(
                    icon: Icons.water_drop,
                    title: 'Baptism Request',
                    color: Colors.cyan,
                    onTap: () => Get.toNamed(AppRoutes.baptismRequest),
                  ),
                  _ServiceCard(
                    icon: Icons.child_care,
                    title: 'Child Dedication',
                    color: Colors.orange,
                    onTap: () => Get.toNamed(AppRoutes.childDedication),
                  ),
                  _ServiceCard(
                    icon: Icons.event,
                    title: 'Activities',
                    color: Colors.green,
                    onTap: () => Get.toNamed(AppRoutes.activities),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
