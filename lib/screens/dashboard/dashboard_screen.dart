import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/dashboard_controller.dart';
import 'package:church_information_system/routes/app_routes.dart';
import 'dart:async';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Show popup banner on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.showPopupBannerIfNeeded(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildModernDrawer(context),
      body: RefreshIndicator(
        onRefresh: controller.loadData,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner with Carousel
              _buildHeroBannerCarousel(),
              
              const SizedBox(height: 20),
              
              // Welcome Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.userName.value,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                )),
              ),
              
              const SizedBox(height: 24),
              
              // Quick Stats Section
              _buildQuickStats(context),
              
              const SizedBox(height: 32),
              
              // Services Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Our Services',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Services Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        _ModernServiceCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Baca Alkitab',
                          subtitle: 'Read & Study',
                          gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                          onTap: () => Get.toNamed(AppRoutes.bible),
                        ),
                        _ModernServiceCard(
                          icon: Icons.favorite_rounded,
                          title: 'Prayer Request',
                          subtitle: 'Share Your Prayer',
                          gradientColors: const [Color(0xFFF093FB), Color(0xFFF5576C)],
                          onTap: () => Get.toNamed(AppRoutes.prayerRequest),
                        ),
                        _ModernServiceCard(
                          icon: Icons.water_drop_rounded,
                          title: 'Baptism',
                          subtitle: 'Request Service',
                          gradientColors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                          onTap: () => Get.toNamed(AppRoutes.baptismRequest),
                        ),
                        _ModernServiceCard(
                          icon: Icons.child_care_rounded,
                          title: 'Child Dedication',
                          subtitle: 'Dedicate Your Child',
                          gradientColors: const [Color(0xFFFA709A), Color(0xFFFEE140)],
                          onTap: () => Get.toNamed(AppRoutes.childDedication),
                        ),
                        _ModernServiceCard(
                          icon: Icons.event_rounded,
                          title: 'Activities',
                          subtitle: 'Upcoming Events',
                          gradientColors: const [Color(0xFF30CFD0), Color(0xFF330867)],
                          onTap: () => Get.toNamed(AppRoutes.activities),
                        ),
                        _ModernServiceCard(
                          icon: Icons.chat_rounded,
                          title: 'Chat Admin',
                          subtitle: 'Get Support',
                          gradientColors: const [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
                          onTap: () => Get.toNamed(AppRoutes.chat),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(() => UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: Text(
                controller.userName.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(controller.userEmail.value),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF2C3E50)),
                ),
              ),
            )),
            _buildDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              onTap: () => Get.back(),
            ),
            _buildDrawerItem(
              icon: Icons.menu_book_rounded,
              title: 'Baca Alkitab',
              onTap: () => Get.toNamed(AppRoutes.bible),
            ),
            _buildDrawerItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            _buildDrawerItem(
              icon: Icons.calendar_today_rounded,
              title: 'Calendar',
              onTap: () => Get.toNamed(AppRoutes.calendar),
            ),
            _buildDrawerItem(
              icon: Icons.family_restroom_rounded,
              title: 'Family Members',
              onTap: () => Get.toNamed(AppRoutes.familyMembers),
            ),
            _buildDrawerItem(
              icon: Icons.chat_rounded,
              title: 'Chat with Admin',
              onTap: () => Get.toNamed(AppRoutes.chat),
            ),
            const Divider(color: Colors.white24, height: 32),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: controller.logout,
              textColor: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildHeroBannerCarousel() {
    return SizedBox(
      height: 200,
      child: Obx(() => PageView.builder(
        controller: controller.bannerPageController,
        onPageChanged: (index) {
          controller.currentBannerIndex.value = index;
        },
        itemCount: controller.bannerItems.length,
        itemBuilder: (context, index) {
          final banner = controller.bannerItems[index];
          return _buildBannerCard(
            title: banner['title']!,
            subtitle: banner['subtitle']!,
            gradientColors: banner['colors'] as List<Color>,
            icon: banner['icon'] as IconData,
          );
        },
      )),
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              icon,
              size: 150,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Obx(() => Row(
              children: List.generate(
                controller.bannerItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.currentBannerIndex.value == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentBannerIndex.value == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.event_rounded,
              title: 'Upcoming',
              value: '5',
              subtitle: 'Events',
              color: const Color(0xFF667EEA),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.favorite_rounded,
              title: 'Active',
              value: '12',
              subtitle: 'Prayers',
              color: const Color(0xFFF5576C),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.people_rounded,
              title: 'Members',
              value: '250+',
              subtitle: 'Community',
              color: const Color(0xFF4FACFE),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ModernServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 80,
                  color: gradientColors[0].withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF2C3E50),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
