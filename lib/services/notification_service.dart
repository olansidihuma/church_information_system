import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Notification service for managing local notifications
/// 
/// Handles initialization, scheduling, and displaying of notifications
/// for church service reminders and updates.
class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  /// Initialize the notification service
  Future<NotificationService> init() async {
    await _initializeNotifications();
    await _requestPermissions();
    return this;
  }
  
  /// Initialize notification plugin
  Future<void> _initializeNotifications() async {
    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }
  
  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (GetPlatform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  }
  
  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // Handle navigation based on payload
      debugPrint('Notification tapped with payload: $payload');
      // You can navigate to specific screens based on payload
    }
  }
  
  /// Show an instant notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'church_channel',
      'Church Notifications',
      channelDescription: 'Notifications for church services and activities',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  /// Schedule a notification for a specific time
  /// 
  /// Used for scheduling reminders 1 hour before church services
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'church_reminder_channel',
      'Church Reminders',
      channelDescription: 'Reminders for upcoming church services',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Note: For actual scheduling, you would use android_alarm_manager_plus
    // or a background task scheduler for production
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      // Convert DateTime to TZDateTime for scheduling
      _convertToTZDateTime(scheduledTime),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
  
  /// Convert DateTime to TZDateTime
  /// Note: In production, use timezone package for proper conversion
  dynamic _convertToTZDateTime(DateTime dateTime) {
    // This is a placeholder - in production, use:
    // import 'package:timezone/timezone.dart' as tz;
    // return tz.TZDateTime.from(dateTime, tz.local);
    return dateTime;
  }
  
  /// Schedule reminder 1 hour before service
  Future<void> scheduleServiceReminder({
    required int serviceId,
    required String serviceName,
    required DateTime serviceTime,
  }) async {
    final reminderTime = serviceTime.subtract(const Duration(hours: 1));
    
    // Only schedule if reminder time is in the future
    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: serviceId,
        title: 'Pengingat Ibadah',
        body: '$serviceName akan dimulai dalam 1 jam',
        scheduledTime: reminderTime,
        payload: 'service_$serviceId',
      );
    }
  }
  
  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
  
  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
