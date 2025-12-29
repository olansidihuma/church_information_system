import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/routes/app_routes.dart';
import 'package:church_information_system/routes/app_pages.dart';
import 'package:church_information_system/services/notification_service.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/config/theme.dart';

/// Main entry point for the Church Information System application
/// 
/// This application provides a comprehensive platform for church members to:
/// - View service schedules and church activities
/// - Request prayer, baptism, and child dedication services
/// - Communicate with church administrators
/// - Receive timely notifications about upcoming services
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services
  await initServices();
  
  runApp(const ChurchInformationSystemApp());
}

/// Initialize all required services before app starts
Future<void> initServices() async {
  // Initialize local storage
  await Get.putAsync(() => StorageService().init());
  
  // Initialize notification service
  await Get.putAsync(() => NotificationService().init());
}

/// Root application widget
class ChurchInformationSystemApp extends StatelessWidget {
  const ChurchInformationSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Church Information System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
