import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String titleKey; // translation key (or plain text if you want)

  const AuthLayout({
    super.key,
    required this.child,
    required this.titleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarZyTheme.bg,
      appBar: AppBar(
        backgroundColor: CarZyTheme.navy,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.directions_car_filled, color: CarZyTheme.red),
            SizedBox(width: 8),
            Text("CarZy", style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'language'.tr(),
            icon: const Icon(Icons.language),
            onPressed: () {
              final locale = context.locale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              context.setLocale(locale);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Text(
              titleKey.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(child: child),
    );
  }
}
