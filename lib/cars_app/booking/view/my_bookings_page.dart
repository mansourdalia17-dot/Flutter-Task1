import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:studio_project/cars_app/core/api_config.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/booking/cubit/my_bookings_cubit.dart';
import 'package:studio_project/cars_app/booking/data/booking_repository.dart';
import 'package:studio_project/cars_app/booking/state/my_bookings_state.dart';
import 'package:studio_project/cars_app/booking/view/booking_screen.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  int? _selectedBookingId;

  String _img(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '';
    if (s.startsWith('http')) return s;
    if (s.startsWith('/')) return ApiConfig.url(s);
    return ApiConfig.url('/$s');
  }

  DateTime? _parseDate(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;

    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;

    final iso2 = DateTime.tryParse(s.replaceFirst(' ', 'T'));
    if (iso2 != null) return iso2;

    return null;
  }

  // ✅ DATE ONLY (no hours)
  String _fmtDate(String? v) {
    final dt = _parseDate(v);
    if (dt == null) return '-';
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  int _calcDays({DateTime? start, DateTime? end, int? fallbackDays}) {
    if (start == null || end == null) return fallbackDays ?? 0;
    final diff = end.difference(start);
    if (diff.isNegative) return fallbackDays ?? 0;

    final d = diff.inDays;
    return (d <= 0) ? 1 : d;
  }

  double _calcTotal({double? totalFromApi, int days = 0, double pricePerDay = 0}) {
    if (totalFromApi != null && totalFromApi > 0) return totalFromApi;
    if (days <= 0 || pricePerDay <= 0) return 0;
    return days * pricePerDay;
  }

  bool _isDone(String? dropoffDate) {
    final end = _parseDate(dropoffDate);
    if (end == null) return false;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return end.isBefore(todayStart);
  }

  String _safe(String? v) {
    final s = (v ?? '').trim();
    return s.isEmpty ? '-' : s;
  }

  String _safeNum(dynamic v) {
    if (v == null) return '-';
    final s = v.toString().trim();
    return s.isEmpty ? '-' : s;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingsCubit(repo: BookingRepository())..loadMyBookings(),
      child: Scaffold(
        backgroundColor: CarZyTheme.bg,
        appBar: AppBar(
          backgroundColor: CarZyTheme.navy,
          foregroundColor: Colors.white,
          title: Text('my_bookings'.tr()),
          actions: [
            IconButton(
              onPressed: () => context.read<MyBookingsCubit>().loadMyBookings(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyBookingsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is! MyBookingsLoaded) return const SizedBox.shrink();

            final items = state.items;
            if (items.isEmpty) return Center(child: Text('no_bookings'.tr()));

            return ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final b = items[i];
                final selected = _selectedBookingId == b.id;

                final car = b.car ??
                    CarModel(
                      id: b.carId,
                      name: 'car'.tr(),
                      model: '',
                      year: null,
                      pricePerDay: 0,
                      officeLocation: null,
                      officeName: null,
                      image: null,
                      capacity: null,
                    );

                final start = _parseDate(b.pickupDate);
                final end = _parseDate(b.dropoffDate);

                final pricePerDay = (car.pricePerDay ?? 0).toDouble();
                final days = _calcDays(start: start, end: end, fallbackDays: b.days);
                final total = _calcTotal(
                  totalFromApi: b.totalPrice,
                  days: days,
                  pricePerDay: pricePerDay,
                );

                final done = _isDone(b.dropoffDate);

                final titleLine = [
                  car.name.trim(),
                  if (car.year != null) car.year.toString(),
                ].where((x) => x.isNotEmpty).join(' - ');

                final pickLoc = (b.pickupLocation ?? '').trim();
                final dropLoc = (b.dropoffLocation ?? '').trim();

                final borderColor = selected ? CarZyTheme.red : const Color(0xFFECECEC);

                return InkWell(
                  onTap: () => setState(() => _selectedBookingId = b.id),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor, width: selected ? 2 : 1),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 14,
                          offset: Offset(0, 10),
                          color: Color(0x12000000),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // ===== Top line (Booking id + Status) =====
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${'your_booking'.tr()} #${b.id}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: CarZyTheme.textDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _StatusChip(done: done),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ===== Car row (image + name/year + office/city + extra specs) =====
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 110,
                                height: 78,
                                color: CarZyTheme.fieldBg,
                                child: (_img(car.image).isEmpty)
                                    ? const Center(
                                  child: Icon(Icons.directions_car, size: 36, color: CarZyTheme.muted),
                                )
                                    : Image.network(
                                  _img(car.image),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image_outlined, size: 34, color: CarZyTheme.muted),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleLine.isEmpty ? 'car'.tr() : titleLine,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: CarZyTheme.textDark,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // ✅ Office Name + City (values stay as-is, labels are translated keys)
                                  Text(
                                    '${'office'.tr()}: ${_safe(car.officeName)}  •  ${'city'.tr()}: ${_safe(car.officeLocation)}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: CarZyTheme.muted,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // ✅ Capacity label translated key, value unchanged
                                  Text(
                                    '${'capacity'.tr()}: ${_safeNum(car.capacity)}  •  ${'year'.tr()}: ${_safeNum(car.year)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: CarZyTheme.muted,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ===== Gray info box (like figma) =====
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EBF6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              _KVRow(
                                left: 'pickup_date'.tr(),
                                right: _fmtDate(b.pickupDate),
                              ),
                              const SizedBox(height: 6),
                              _KVRow(
                                left: 'dropoff_date'.tr(),
                                right: _fmtDate(b.dropoffDate),
                              ),
                              const SizedBox(height: 6),
                              _KVRow(
                                left: 'pickup_location'.tr(),
                                right: pickLoc.isEmpty ? '-' : pickLoc,
                              ),
                              const SizedBox(height: 6),
                              _KVRow(
                                left: 'dropoff_location'.tr(),
                                right: dropLoc.isEmpty ? '-' : dropLoc,
                              ),
                              const SizedBox(height: 6),
                              _KVRow(
                                left: 'days'.tr(),
                                right: '$days',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ===== Total row =====
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${'total'.tr()} (${days.toString()} ${'days'.tr()})',
                                style: const TextStyle(
                                  color: CarZyTheme.textDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: CarZyTheme.navy,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ===== Actions =====
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: selected
                                    ? () async {
                                  final myCubit = context.read<MyBookingsCubit>();
                                  final updated = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingScreen(car: car, existingBooking: b),
                                    ),
                                  );
                                  if (!mounted) return;
                                  if (updated == true) {
                                    myCubit.loadMyBookings();
                                    setState(() => _selectedBookingId = null);
                                  }
                                }
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: CarZyTheme.navy,
                                  side: BorderSide(
                                    color: selected ? CarZyTheme.navy : const Color(0x22000000),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'edit'.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: selected
                                    ? () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('delete_booking_title'.tr()),
                                      content: Text('delete_booking_msg'.tr()),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('cancel'.tr()),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: CarZyTheme.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('delete'.tr()),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    context.read<MyBookingsCubit>().deleteAndRefresh(b.id);
                                    setState(() => _selectedBookingId = null);
                                  }
                                }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CarZyTheme.navy,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'delete'.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ===== Helpers =====

class _StatusChip extends StatelessWidget {
  final bool done;
  const _StatusChip({required this.done});

  @override
  Widget build(BuildContext context) {
    final bg = done ? const Color(0xFFE8F7EE) : const Color(0xFFEFF4FF);
    final fg = done ? const Color(0xFF1A7F37) : CarZyTheme.navy;
    final text = done ? 'status_done'.tr() : 'status_active'.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String left;
  final String right;

  const _KVRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(
              color: CarZyTheme.textDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          right,
          style: const TextStyle(
            color: CarZyTheme.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
