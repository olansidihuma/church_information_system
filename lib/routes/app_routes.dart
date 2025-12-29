/// Application route constants
/// 
/// Defines all route names used in the application for navigation
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();
  
  // Initial Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Main Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  
  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  
  // Service Request Routes
  static const String prayerRequest = '/prayer-request';
  static const String baptismRequest = '/baptism-request';
  static const String childDedication = '/child-dedication';
  
  // Activity Routes
  static const String activities = '/activities';
  static const String activityDetail = '/activity-detail';
  static const String calendar = '/calendar';
  
  // Communication Routes
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  
  // Family Routes
  static const String familyMembers = '/family-members';
  static const String addFamilyMember = '/add-family-member';
  
  // Admin Routes (if needed)
  static const String adminDashboard = '/admin/dashboard';
  static const String scheduleActivity = '/admin/schedule-activity';
  static const String sendNotification = '/admin/send-notification';
}
