import 'package:get/get.dart';
import 'package:church_information_system/routes/app_routes.dart';
import 'package:church_information_system/screens/splash/splash_screen.dart';
import 'package:church_information_system/screens/splash/splash_binding.dart';
import 'package:church_information_system/screens/auth/login_screen.dart';
import 'package:church_information_system/screens/auth/login_binding.dart';
import 'package:church_information_system/screens/auth/register_screen.dart';
import 'package:church_information_system/screens/auth/register_binding.dart';
import 'package:church_information_system/screens/home/home_screen.dart';
import 'package:church_information_system/screens/home/home_binding.dart';
import 'package:church_information_system/screens/dashboard/dashboard_screen.dart';
import 'package:church_information_system/screens/dashboard/dashboard_binding.dart';
import 'package:church_information_system/screens/profile/profile_screen.dart';
import 'package:church_information_system/screens/profile/profile_binding.dart';
import 'package:church_information_system/screens/services/prayer_request_screen.dart';
import 'package:church_information_system/screens/services/baptism_request_screen.dart';
import 'package:church_information_system/screens/services/child_dedication_screen.dart';
import 'package:church_information_system/screens/services/service_binding.dart';
import 'package:church_information_system/screens/activities/activities_screen.dart';
import 'package:church_information_system/screens/activities/activities_binding.dart';
import 'package:church_information_system/screens/activities/calendar_screen.dart';
import 'package:church_information_system/screens/chat/chat_screen.dart';
import 'package:church_information_system/screens/chat/chat_binding.dart';
import 'package:church_information_system/screens/family/family_members_screen.dart';
import 'package:church_information_system/screens/family/add_family_member_screen.dart';
import 'package:church_information_system/screens/family/family_binding.dart';
import 'package:church_information_system/screens/bible/bible_screen.dart';
import 'package:church_information_system/screens/bible/bible_reading_screen.dart';
import 'package:church_information_system/screens/bible/bible_chapter_screen.dart';
import 'package:church_information_system/screens/bible/bible_progress_screen.dart';
import 'package:church_information_system/screens/bible/bible_schedule_screen.dart';
import 'package:church_information_system/screens/bible/bible_binding.dart';

/// Application pages configuration
/// 
/// Maps route names to their respective screens and bindings
class AppPages {
  // Prevent instantiation
  AppPages._();
  
  static final List<GetPage> pages = [
    // Splash Screen
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    
    // Authentication
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    
    // Main Screens
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    
    // Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    
    // Service Requests
    GetPage(
      name: AppRoutes.prayerRequest,
      page: () => const PrayerRequestScreen(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.baptismRequest,
      page: () => const BaptismRequestScreen(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.childDedication,
      page: () => const ChildDedicationScreen(),
      binding: ServiceBinding(),
    ),
    
    // Activities
    GetPage(
      name: AppRoutes.activities,
      page: () => const ActivitiesScreen(),
      binding: ActivitiesBinding(),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarScreen(),
      binding: ActivitiesBinding(),
    ),
    
    // Chat
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    
    // Family Management
    GetPage(
      name: AppRoutes.familyMembers,
      page: () => const FamilyMembersScreen(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: AppRoutes.addFamilyMember,
      page: () => const AddFamilyMemberScreen(),
      binding: FamilyBinding(),
    ),
    
    // Bible Reading
    GetPage(
      name: AppRoutes.bible,
      page: () => const BibleScreen(),
      binding: BibleBinding(),
    ),
    GetPage(
      name: AppRoutes.bibleReading,
      page: () => const BibleReadingScreen(),
      binding: BibleBinding(),
    ),
    GetPage(
      name: AppRoutes.bibleChapter,
      page: () => const BibleChapterScreen(),
      binding: BibleBinding(),
    ),
    GetPage(
      name: AppRoutes.bibleProgress,
      page: () => const BibleProgressScreen(),
      binding: BibleBinding(),
    ),
    GetPage(
      name: AppRoutes.bibleSchedule,
      page: () => const BibleScheduleScreen(),
      binding: BibleBinding(),
    ),
  ];
}
