import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars_login/view/cars_login_screen.dart';
import 'package:studio_project/cars_app/cars_login/view/cars_signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String _bgImagePath = 'assets/image/png/black.png';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    // responsive sizing
    final horizontalPad = (w * 0.06).clamp(16.0, 26.0);
    final verticalPad = (h * 0.03).clamp(16.0, 28.0);

    final titleSize = (w * 0.075).clamp(22.0, 32.0);
    final subtitleSize = (w * 0.038).clamp(12.0, 15.0);

    final cardMaxWidth = w.clamp(0, 420).toDouble(); // max 420
    final cardPad = (w * 0.045).clamp(14.0, 20.0);
    final cardRadius = (w * 0.04).clamp(14.0, 20.0);

    final buttonVPad = (h * 0.018).clamp(12.0, 16.0);
    final buttonRadius = (w * 0.09).clamp(22.0, 34.0);

    final topSafe = mq.padding.top;
    final langBtnSize = (w * 0.12).clamp(44.0, 54.0);
    final langBtnMargin = (w * 0.045).clamp(14.0, 20.0);

    return Scaffold(
      backgroundColor: CarZyTheme.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Background image
            Positioned.fill(
              child: Image.asset(
                _bgImagePath,
                fit: BoxFit.cover,
              ),
            ),

            // ✅ Dark/soft overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),

            // ✅ Top-right language icon (earth)
            Positioned(
              top: topSafe + langBtnMargin,
              right: langBtnMargin,
              child: SizedBox(
                width: langBtnSize,
                height: langBtnSize,
                child: Material(
                  color: Colors.black.withOpacity(0.25),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showLanguageSheet(context),
                    child: Tooltip(
                      message: 'language'.tr(),
                      child: const Icon(
                        Icons.language, // 🌍 earth icon
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Center content
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPad,
                        vertical: verticalPad,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'welcome_title'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: (h * 0.01).clamp(6.0, 10.0)),
                          Text(
                            'welcome_subtitle'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: subtitleSize,
                            ),
                          ),
                          SizedBox(height: (h * 0.03).clamp(16.0, 26.0)),

                          // ✅ Center card
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: cardMaxWidth),
                            child: Container(
                              padding: EdgeInsets.all(cardPad),
                              decoration: BoxDecoration(
                                color: CarZyTheme.navy.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(cardRadius),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: (w * 0.05).clamp(14.0, 20.0),
                                    spreadRadius: 2,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'start_now'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (w * 0.045).clamp(16.0, 19.0),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: (h * 0.02).clamp(10.0, 16.0)),

                                  // ✅ Login
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CarsLoginScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: CarZyTheme.red,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: buttonVPad),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(buttonRadius),
                                        ),
                                      ),
                                      child: Text(
                                        'sign_in'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: (w * 0.04).clamp(13.0, 15.0),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: (h * 0.012).clamp(8.0, 12.0)),

                                  // ✅ Sign up
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CarsSignupScreen(),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(color: Colors.white70),
                                        padding: EdgeInsets.symmetric(vertical: buttonVPad),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(buttonRadius),
                                        ),
                                      ),
                                      child: Text(
                                        'sign_up'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: (w * 0.04).clamp(13.0, 15.0),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
        final mq = MediaQuery.of(context);
        final w = mq.size.width;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: (mq.size.height * 0.012).clamp(8.0, 12.0)),
              Container(
                width: (w * 0.12).clamp(44.0, 56.0),
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: (mq.size.height * 0.012).clamp(8.0, 12.0)),
              Text(
                'choose_language'.tr(),
                style: TextStyle(
                  color: CarZyTheme.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: (w * 0.045).clamp(14.0, 16.0),
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
