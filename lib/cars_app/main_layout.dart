import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studio_project/cars_app/contact/message_view.dart';

import 'package:studio_project/cars_app/core/auth_storage.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';

import 'package:studio_project/cars_app/cars/view/cars_home_screen.dart';
import 'package:studio_project/cars_app/cars/view/cars_list_screen.dart';
import 'package:studio_project/cars_app/booking/view/my_bookings_page.dart';

import 'package:studio_project/cars_app/screens/auth_layout.dart';
import 'package:studio_project/cars_app/screens/welcome_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  late final List<Widget> _pages = [
    CarsHomeScreen(
      onOpenAllCars: () => setState(() => _index = 1),
    ),
    const CarsListScreen(),
    const MyBookingsPage(),
    const ContactMessageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarZyTheme.bg,
      drawer: _buildDrawer(context),

      // ✅ AppBar only in Home tab
      appBar: _index == 0 ? _buildAppBar(context) : null,

      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/carzy_logo.png',
            height: 26,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.local_taxi_rounded,
              size: 26,
              color: CarZyTheme.red,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'CarZy',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'language'.tr(),
          icon: const Icon(Icons.language, color: Colors.black54),
          onPressed: () => _showLanguageSheet(context),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
      type: BottomNavigationBarType.fixed,
      backgroundColor: CarZyTheme.navy,
      selectedItemColor: CarZyTheme.red,
      unselectedItemColor: Colors.white70,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: 'home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.directions_car_rounded),
          label: 'cars'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book_online_rounded),
          label: 'my_bookings'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.contact_mail_rounded),
          label: 'contact_us'.tr(),
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: CarZyTheme.bg,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: CarZyTheme.navy),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/carzy_logo.png',
                  height: 40,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_taxi_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'CarZy',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'drawer_tagline'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  context,
                  icon: Icons.home_rounded,
                  title: 'home'.tr(),
                  onTap: () => _goTab(0),
                ),
                _drawerItem(
                  context,
                  icon: Icons.directions_car_rounded,
                  title: 'cars'.tr(),
                  onTap: () => _goTab(1),
                ),
                const Divider(),
                _drawerItem(
                  context,
                  icon: Icons.book_online_rounded,
                  title: 'my_bookings'.tr(),
                  onTap: () => _goTab(2),
                ),
                _drawerItem(
                  context,
                  icon: Icons.contact_mail_rounded,
                  title: 'contact_us'.tr(),
                  onTap: () => _goTab(3),
                ),
                const Divider(),
                _drawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'logout'.tr(),
                  onTap: () => _logout(context),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    final color = isDestructive ? Colors.redAccent : CarZyTheme.navy;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(
          color: CarZyTheme.navy,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  void _goTab(int tabIndex) {
    Navigator.of(context).pop();
    setState(() => _index = tabIndex);
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.of(context).pop();
    await AuthStorage.clearSession();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AuthLayout(
          titleKey: 'welcome',
          child: WelcomeScreen(),
        ),
      ),
          (_) => false,
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final locales = context.supportedLocales;
    final current = context.locale;

    showModalBottomSheet(
      context: context,
      backgroundColor: CarZyTheme.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'choose_language'.tr(),
                style: const TextStyle(
                  color: CarZyTheme.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...locales.map((loc) {
                final selected = loc == current;
                return ListTile(
                  leading: Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? CarZyTheme.red : Colors.black38,
                  ),
                  title: Text(loc.languageCode.toUpperCase()),
                  onTap: () async {
                    await context.setLocale(loc);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

// keep your ContactUsScreen as you already have it
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('contact_us_coming_soon'.tr()));
  }
}
