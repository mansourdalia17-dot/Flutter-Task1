import 'package:flutter/material.dart';
import 'package:studio_project/cars_app/cars/view/cars_list_screen.dart';

import 'booking/view/my_bookings_page.dart';
import 'core/carzy_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  final _pages = const [
    CarsListScreen(),
    MyBookingsPage(),
    _SettingsStub(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (v) => setState(() => _index = v),
        selectedItemColor: CarZyTheme.red,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Cars'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _SettingsStub extends StatelessWidget {
  const _SettingsStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarZyTheme.bg,
      appBar: AppBar(backgroundColor: CarZyTheme.navy, title: const Text('Settings')),
      body: const Center(child: Text('Settings')),
    );
  }
}
