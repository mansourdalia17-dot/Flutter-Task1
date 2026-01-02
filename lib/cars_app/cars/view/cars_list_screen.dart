import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_project/cars_app/booking/data/cars_reprository.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars/cubit/cars_cubit.dart';
import 'package:studio_project/cars_app/cars/state/cars_state.dart';
import 'package:studio_project/cars_app/cars/view/car_details_page.dart';

class CarsListScreen extends StatelessWidget {
  const CarsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(repo: CarRepository())..loadCars(),
      child: Scaffold(
        backgroundColor: CarZyTheme.bg,

        // ✅ White app bar + localized title
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: CarZyTheme.navy),
          title: Text(
            'cars_list_title'.tr(),
            style: const TextStyle(
              color: CarZyTheme.navy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        body: BlocBuilder<CarsCubit, CarsState>(
          builder: (context, state) {
            if (state is CarsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CarsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state is! CarsLoaded) return const SizedBox.shrink();

            final cubit = context.read<CarsCubit>();
            final cars = state.cars;

            final cities = state.allCars
                .map((e) => (e.officeLocation ?? '').trim())
                .where((e) => e.isNotEmpty)
                .toSet()
                .toList()
              ..sort();

            final width = MediaQuery.of(context).size.width;

            final crossAxisCount = width >= 1100
                ? 4
                : width >= 800
                ? 3
                : 2;

            // ✅ Better fixed height to prevent overflow and "fit content"
            final tileHeight = crossAxisCount == 4
                ? 300.0
                : crossAxisCount == 3
                ? 315.0
                : 335.0;

            return Column(
              children: [
                // ================= Filters =================
                Container(
                  color: Colors.white70,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: state.selectedCity,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'city'.tr(),
                                icon: Icons.location_on_outlined,
                              ),
                              dropdownColor: Colors.white,
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('all'.tr()),
                                ),
                                ...cities.map(
                                      (c) => DropdownMenuItem<String?>(
                                    value: c,
                                    child: Text(c),
                                  ),
                                ),
                              ],
                              onChanged: (v) => cubit.loadByCity(v),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              value: state.minYear,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'min_year'.tr(),
                                icon: Icons.calendar_month_outlined,
                              ),
                              dropdownColor: Colors.white,
                              items: [
                                DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('all'.tr()),
                                ),
                                DropdownMenuItem<int?>(
                                  value: 2015,
                                  child: Text('year_plus'.tr(args: ['2015'])),
                                ),
                                DropdownMenuItem<int?>(
                                  value: 2018,
                                  child: Text('year_plus'.tr(args: ['2018'])),
                                ),
                                DropdownMenuItem<int?>(
                                  value: 2020,
                                  child: Text('year_plus'.tr(args: ['2020'])),
                                ),
                                DropdownMenuItem<int?>(
                                  value: 2022,
                                  child: Text('year_plus'.tr(args: ['2022'])),
                                ),
                              ],
                              onChanged: (v) => cubit.loadByMinYear(v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueGrey),
                            foregroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => cubit.loadByPrice(asc: !state.priceAsc),
                          icon: const Icon(Icons.swap_vert),
                          label: Text(
                            state.priceAsc
                                ? 'price_low_high'.tr()
                                : 'price_high_low'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= Grid =================
                Expanded(
                  child: cars.isEmpty
                      ? Center(child: Text('no_cars_found'.tr()))
                      : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: tileHeight,
                    ),
                    itemCount: cars.length,
                    itemBuilder: (context, i) {
                      final car = cars[i];
                      final price = (car.pricePerDay ?? 0).toStringAsFixed(0);

                      return _CarGridItem(
                        name: car.name,
                        year: car.year, // ✅ keep year only (filter is by year)
                        priceText: '$price ${'per_day'.tr()}',
                        officeLocation: car.officeLocation,
                        imageUrl: car.image,
                        onOpen: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarDetailsPage(cars: cars, initialIndex: i),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CarGridItem extends StatelessWidget {
  final String name;
  final int? year; // ✅ keep year only
  final String priceText;
  final String? officeLocation;
  final String? imageUrl;
  final VoidCallback onOpen;

  const _CarGridItem({
    required this.name,
    required this.year,
    required this.priceText,
    required this.officeLocation,
    required this.imageUrl,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Removed model from subtitle (duplicate)
    final subtitle = [
      if (year != null) year.toString(),
      if ((officeLocation ?? '').trim().isNotEmpty) officeLocation!.trim(),
    ].join(' • ');

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 10),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildImage()),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: CarZyTheme.textDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: CarZyTheme.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      priceText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CarZyTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarZyTheme.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: onOpen,
                        child: Text('book_now'.tr()),
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

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return Container(
        color: CarZyTheme.fieldBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 42, color: CarZyTheme.muted),
        ),
      );
    }

    return Image.network(
      imageUrl!.trim(),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: CarZyTheme.fieldBg,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: CarZyTheme.fieldBg,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 40, color: CarZyTheme.muted),
          ),
        );
      },
    );
  }
}
