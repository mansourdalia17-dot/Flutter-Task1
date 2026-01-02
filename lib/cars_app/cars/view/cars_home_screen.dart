import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_project/cars_app/booking/data/cars_reprository.dart';
import 'package:studio_project/cars_app/core/api_config.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars/cubit/cars_cubit.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';
import 'package:studio_project/cars_app/cars/state/cars_state.dart';
import 'package:studio_project/cars_app/cars/view/car_details_page.dart';

class CarsHomeScreen extends StatefulWidget {
  final VoidCallback onOpenAllCars;

  const CarsHomeScreen({
    super.key,
    required this.onOpenAllCars,
  });

  @override
  State<CarsHomeScreen> createState() => _CarsHomeScreenState();
}

class _CarsHomeScreenState extends State<CarsHomeScreen> {
  // Promo slider (3 slides)
  final PageController _promoCtrl = PageController();
  int _promoIndex = 0;
  Timer? _promoTimer;

  // Cars slider
  late final PageController _carsCtrl;
  int _carsIndex = 0;
  int _carsCount = 0;
  Timer? _carsTimer;

  // ✅ Your promo images (from assets)
  final List<String> _promoImages = const [
    'assets/image/png/img.png',
    'assets/image/png/img_1.png',
    'assets/image/png/img_2.png',
  ];

  @override
  void initState() {
    super.initState();

    _carsCtrl = PageController(viewportFraction: 0.56);

    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (!_promoCtrl.hasClients) return;

      final next = (_promoIndex + 1) % 3;
      _promoCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
      );
    });

    _carsTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      if (!_carsCtrl.hasClients) return;
      if (_carsCount <= 1) return;

      final next = (_carsIndex + 1) % _carsCount;
      _carsCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _carsTimer?.cancel();
    _promoCtrl.dispose();
    _carsCtrl.dispose();
    super.dispose();
  }

  String _img(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '';
    if (s.startsWith('http')) return s;
    if (s.startsWith('/')) return ApiConfig.url(s);
    return ApiConfig.url('/$s');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(repo: CarRepository())..loadCars(),
      child: BlocBuilder<CarsCubit, CarsState>(
        builder: (context, state) {
          if (state is CarsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CarsFailure) {
            return Center(child: Text(state.message));
          }
          if (state is! CarsLoaded) return const SizedBox.shrink();

          final List<CarModel> allCars = state.allCars;
          final List<CarModel> homeCars =
          allCars.length > 8 ? allCars.take(8).toList() : allCars;

          _carsCount = homeCars.length;
          if (_carsIndex >= _carsCount && _carsCount > 0) _carsIndex = 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Title =====
                Text(
                  'welcome_to_our_app'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: CarZyTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // ===== Promo slider (with your images) =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x11000000)),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 10),
                          color: Color(0x0F000000),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _promoCtrl,
                            onPageChanged: (i) => setState(() => _promoIndex = i),
                            children: [
                              _promoSlide(
                                imageAsset: _promoImages[0],
                                title: 'promo_1_title'.tr(),
                                subtitle: 'promo_1_sub'.tr(),
                                badgeText: 'promo_badge'.tr(args: ['30']),
                              ),
                              _promoSlide(
                                imageAsset: _promoImages[1],
                                title: 'promo_2_title'.tr(),
                                subtitle: 'promo_2_sub'.tr(),
                                badgeText: 'promo_badge'.tr(args: ['20']),
                              ),
                              _promoSlide(
                                imageAsset: _promoImages[2],
                                title: 'promo_3_title'.tr(),
                                subtitle: 'promo_3_sub'.tr(),
                                badgeText: 'promo_badge'.tr(args: ['10']),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _dots(count: 3, index: _promoIndex),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ NEW: Jordan location card under promo
                const SizedBox(height: 12),
                _jordanLocationCard(),
                const SizedBox(height: 18),

                // ===== Recommended + See All =====
                Row(
                  children: [
                    Text(
                      'recommended'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: CarZyTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.onOpenAllCars,
                      child: Row(
                        children: [
                          Text(
                            'see_all'.tr(),
                            style: const TextStyle(
                              color: CarZyTheme.muted,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: CarZyTheme.muted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===== Cars slider (smaller + fits + borders) =====
                SizedBox(
                  height: 205,
                  child: PageView.builder(
                    controller: _carsCtrl,
                    onPageChanged: (i) => setState(() => _carsIndex = i),
                    itemCount: homeCars.length,
                    itemBuilder: (context, i) {
                      final car = homeCars[i];
                      final imageUrl = _img(car.image);
                      final price = (car.pricePerDay ?? 0).toStringAsFixed(0);

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _recommendedCarCard(
                          active: i == _carsIndex,
                          imageUrl: imageUrl,
                          name: car.name,
                          yearText: car.year?.toString() ?? '-',
                          priceText: '\$$price ${'per_day_short'.tr()}',
                          onTap: () {
                            final typedCars = List<CarModel>.from(allCars);
                            final globalIndex =
                            typedCars.indexWhere((x) => x.id == car.id);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CarDetailsPage(
                                  cars: typedCars,
                                  initialIndex: globalIndex < 0 ? 0 : globalIndex,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== Widgets =====

  Widget _jordanLocationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x11000000)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 8),
            color: Color(0x0D000000),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.location_on_outlined, color: CarZyTheme.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Jordan — The app is available in Jordan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CarZyTheme.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoSlide({
    required String imageAsset,
    required String title,
    required String subtitle,
    required String badgeText,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: CarZyTheme.bg,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: CarZyTheme.textDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: CarZyTheme.muted,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: CarZyTheme.navy,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendedCarCard({
    required bool active,
    required String imageUrl,
    required String name,
    required String yearText,
    required String priceText,
    required VoidCallback onTap,
  }) {
    final borderColor = active ? CarZyTheme.navy : const Color(0x22000000);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: active ? 1.6 : 1.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 10),
              color: Color(0x12000000),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: CarZyTheme.bg,
                  padding: const EdgeInsets.all(10),

                  // ✅ Center the item (image/icon) inside the bordered box
                  child: Center(
                    child: imageUrl.isEmpty
                        ? const Icon(
                      Icons.directions_car_rounded,
                      size: 46,
                      color: CarZyTheme.muted,
                    )
                        : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: CarZyTheme.muted,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CarZyTheme.textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      yearText,
                      style: const TextStyle(
                        color: CarZyTheme.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      priceText,
                      style: const TextStyle(
                        color: CarZyTheme.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
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

  Widget _dots({required int count, required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active ? CarZyTheme.navy : const Color(0x22000000),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
