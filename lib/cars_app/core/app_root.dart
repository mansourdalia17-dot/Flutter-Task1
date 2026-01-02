import 'package:flutter/material.dart';
import 'package:studio_project/cars_app/core/auth_storage.dart';
import 'package:studio_project/cars_app/main_layout.dart';
import 'package:studio_project/cars_app/screens/auth_layout.dart';
import 'package:studio_project/cars_app/screens/welcome_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthStorage.getToken(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final token = snap.data;
        if (token != null && token.isNotEmpty) {
          return const MainLayout();
        }

        return const AuthLayout(
          titleKey: 'welcome',
          child: WelcomeScreen(),
        );
      },
    );
  }
}
