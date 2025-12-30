import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/services/storage_service.dart';
import 'package:church_information_system/routes/app_routes.dart';
import 'dart:async';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final userName = ''.obs;
  final userEmail = ''.obs;
  
  // Banner carousel
  late PageController bannerPageController;
  final currentBannerIndex = 0.obs;
  Timer? _bannerTimer;
  
  // Banner items
  final bannerItems = [
    {
      'title': 'Welcome to Church',
      'subtitle': 'Join us in worship and fellowship',
      'icon': Icons.church_rounded,
      'colors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    },
    {
      'title': 'Prayer & Worship',
      'subtitle': 'Share your prayers with our community',
      'icon': Icons.favorite_rounded,
      'colors': [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    },
    {
      'title': 'Upcoming Events',
      'subtitle': 'Check out our activities and services',
      'icon': Icons.event_rounded,
      'colors': [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    },
  ];

  @override
  void onInit() {
    super.onInit();
    bannerPageController = PageController(initialPage: 0);
    loadUserData();
    loadData();
    _startBannerAutoScroll();
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  void loadUserData() {
    userName.value = _storageService.getUserName() ?? 'User';
    userEmail.value = _storageService.getUserEmail() ?? '';
  }

  Future<void> loadData() async {
    // Load dashboard data
    await Future.delayed(const Duration(seconds: 1));
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (currentBannerIndex.value < bannerItems.length - 1) {
        currentBannerIndex.value++;
      } else {
        currentBannerIndex.value = 0;
      }
      
      if (bannerPageController.hasClients) {
        bannerPageController.animateToPage(
          currentBannerIndex.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void showPopupBannerIfNeeded(BuildContext context) {
    // Check if user has seen the popup banner
    final hasSeenPopup = _storageService.getBool('has_seen_dashboard_popup') ?? false;
    
    if (!hasSeenPopup) {
      // Show popup after a short delay
      Future.delayed(const Duration(milliseconds: 800), () {
        _showWelcomePopup(context);
      });
    }
  }

  void _showWelcomePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildPopupContent(context),
        );
      },
    );
  }

  Widget _buildPopupContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.church_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to ${userName.value}!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay connected with our church community, explore services, and grow in faith together.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _storageService.saveBool('has_seen_dashboard_popup', true);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              _storageService.saveBool('has_seen_dashboard_popup', true);
              Navigator.of(context).pop();
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await _storageService.logout();
    Get.offAllNamed(AppRoutes.home);
    Get.snackbar('Success', 'Logged out successfully');
  }
}
