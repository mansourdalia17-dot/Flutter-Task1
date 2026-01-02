import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:studio_project/cars_app/core/api_config.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';
import 'package:studio_project/cars_app/booking/view/booking_screen.dart';

class CarDetailsPage extends StatefulWidget {
  final List<CarModel> cars;
  final int initialIndex;

  const CarDetailsPage({
    super.key,
    required this.cars,
    required this.initialIndex,
  });

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late int _index;
  bool _fav = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  String _img(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '';
    if (s.startsWith('http')) return s;
    if (s.startsWith('/')) return ApiConfig.url(s);
    return ApiConfig.url('/$s');
  }

  void _next() {
    if (_index < widget.cars.length - 1) setState(() => _index++);
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
  }

  String _capacityText(CarModel car) {
    final v = car.capacity;
    if (v == null) return '-';
    final s = v.toString().trim();
    return s.isEmpty ? '-' : s;
  }

  String _plateText(CarModel car) {
    final v = car.licensePlate;
    if (v == null) return '-';
    final s = v.toString().trim();
    return s.isEmpty ? '-' : s;
  }

  String _yearText(CarModel car) => (car.year?.toString() ?? '-');

  String _cityText(CarModel car) {
    final s = (car.officeLocation ?? '').trim();
    return s.isEmpty ? '-' : s;
  }

  String _priceText(CarModel car) {
    final p = (car.pricePerDay ?? 0).toStringAsFixed(0);
    return '\$$p';
  }

  String _safeText(String? v) {
    final s = (v ?? '').trim();
    return s.isEmpty ? '-' : s;
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.cars[_index];
    final priceNum = (car.pricePerDay ?? 0).toStringAsFixed(0);

    final safeName = (car.name).trim().isEmpty ? 'car_details'.tr() : car.name;

    return Scaffold(
      backgroundColor: CarZyTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Top Bar (white, like photo) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Row(
                children: [
                  _circleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      safeName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CarZyTheme.textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _circleIcon(
                    icon: _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: _fav ? CarZyTheme.red : CarZyTheme.muted,
                    onTap: () => setState(() => _fav = !_fav),
                  ),
                ],
              ),
            ),

            // ===== Scrollable content =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Image + arrows overlay (like photo) =====
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            offset: Offset(0, 10),
                            color: Color(0x12000000),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: _buildImage(_img(car.image)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 6,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _circleIcon(
                                icon: Icons.chevron_left_rounded,
                                onTap: _prev,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _circleIcon(
                                icon: Icons.chevron_right_rounded,
                                onTap: _next,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== Title area under image =====
                    Text(
                      safeName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: CarZyTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== Specification (like photo) =====
                    Text(
                      'specification'.tr(),
                      style: const TextStyle(
                        color: CarZyTheme.textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ✅ Now Year + City + Price look like Capacity/Plate/Office cards
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _specCard(
                          icon: Icons.event_seat_outlined,
                          title: 'capacity'.tr(),
                          subtitle: _capacityText(car),
                        ),
                        _specCard(
                          icon: Icons.confirmation_number_outlined,
                          title: 'license_plate'.tr(),
                          subtitle: _plateText(car),
                        ),
                        _specCard(
                          icon: Icons.store_mall_directory_outlined,
                          title: 'office'.tr(),
                          subtitle: _safeText(car.officeName),
                        ),

                        // ✅ NEW cards (same style)
                        _specCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'year'.tr(),
                          subtitle: _yearText(car),
                        ),
                        _specCard(
                          icon: Icons.location_on_outlined,
                          title: 'city'.tr(),
                          subtitle: _cityText(car),
                        ),
                        _specCard(
                          icon: Icons.attach_money_rounded,
                          title: 'price'.tr(),
                          subtitle: _priceText(car),
                        ),
                      ],
                    ),

                    const SizedBox(height: 100), // space for bottom bar
                  ],
                ),
              ),
            ),

            // ===== Bottom bar (price + button) =====
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, -8),
                      color: Color(0x14000000),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'price'.tr(),
                          style: const TextStyle(
                            color: CarZyTheme.textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$$priceNum',
                          style: const TextStyle(
                            color: CarZyTheme.navy,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'per_day_short'.tr(),
                          style: const TextStyle(
                            color: CarZyTheme.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarZyTheme.navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BookingScreen(car: car)),
                          );
                        },
                        child: Text(
                          'rent_now'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w800),
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
    );
  }

  Widget _buildImage(String url) {
    if (url.trim().isEmpty) {
      return Container(
        color: CarZyTheme.fieldBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 52, color: CarZyTheme.muted),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: CarZyTheme.fieldBg,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (_, __, ___) {
        return Container(
          color: CarZyTheme.fieldBg,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 46, color: CarZyTheme.muted),
          ),
        );
      },
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? CarZyTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _specCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 112,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: CarZyTheme.red, size: 18),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CarZyTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CarZyTheme.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
