import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';

// ✅ Change this import to your actual my bookings screen file
import 'package:studio_project/cars_app/booking/view/my_bookings_page.dart';

class BookingSuccessScreen extends StatelessWidget {
  final CarModel car;

  const BookingSuccessScreen({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFD),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'booking_success_title'.tr(),
          style: const TextStyle(
            color: CarZyTheme.textDark,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, size: 86, color: CarZyTheme.red),
              const SizedBox(height: 14),
              Text(
                'booking_success_message'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: CarZyTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                car.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CarZyTheme.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CarZyTheme.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MyBookingsPage()),
                    );
                  },
                  child: Text(
                    'my_bookings_button'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
