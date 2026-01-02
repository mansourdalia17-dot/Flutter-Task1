import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studio_project/cars_app/booking/view/booking_success_screen.dart';

import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/booking/cubit/booking_cubit.dart';
import 'package:studio_project/cars_app/booking/data/booking_repository.dart';
import 'package:studio_project/cars_app/booking/model/booking_model.dart';
import 'package:studio_project/cars_app/booking/model/booking_request_model.dart';
import 'package:studio_project/cars_app/booking/state/booking_state.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';

class BookingScreen extends StatefulWidget {
  final CarModel car;
  final BookingModel? existingBooking;

  const BookingScreen({
    super.key,
    required this.car,
    this.existingBooking,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _pickupLocation;
  late final TextEditingController _dropoffLocation;
  late final TextEditingController _pickupDate;
  late final TextEditingController _dropoffDate;

  final _dateFmt = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final b = widget.existingBooking;

    _pickupLocation = TextEditingController(text: b?.pickupLocation ?? '');
    _dropoffLocation = TextEditingController(text: b?.dropoffLocation ?? '');

    _pickupDate = TextEditingController(text: _toDateOnlyString(b?.pickupDate));
    _dropoffDate = TextEditingController(text: _toDateOnlyString(b?.dropoffDate));
  }

  @override
  void dispose() {
    _pickupLocation.dispose();
    _dropoffLocation.dispose();
    _pickupDate.dispose();
    _dropoffDate.dispose();
    super.dispose();
  }

  // ---- date helpers (date only, no hours) ----
  String _toDateOnlyString(String? raw) {
    final s = (raw ?? '').trim();
    if (s.isEmpty) return '';
    final dt = DateTime.tryParse(s) ?? DateTime.tryParse(s.replaceFirst(' ', 'T'));
    if (dt == null) return s;
    return _dateFmt.format(DateTime(dt.year, dt.month, dt.day));
  }

  DateTime? _parseDateOnly(String? raw) {
    final s = (raw ?? '').trim();
    if (s.isEmpty) return null;
    final dt = DateTime.tryParse(s) ?? DateTime.tryParse(s.replaceFirst(' ', 'T'));
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }

  // ---- DatePicker with white dialog + RED selected day ----
  Future<void> _pickDate({
    required TextEditingController controller,
    DateTime? firstDate,
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    final init = initialDate ??
        _parseDateOnly(controller.text) ??
        DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: firstDate ?? DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 5, 12, 31),
      builder: (context, child) {
        final theme = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFBFBFD),
          dialogBackgroundColor: Colors.white,

          // ✅ IMPORTANT: DialogThemeData (fixes your error)
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),

          colorScheme: ColorScheme.light(
            primary: CarZyTheme.red, // ✅ selected day / buttons
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: CarZyTheme.textDark,
          ),

          // ✅ Modern replacement for MaterialStateProperty
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,

            headerBackgroundColor: Colors.white,
            headerForegroundColor: CarZyTheme.textDark,

            todayBorder: const BorderSide(color: CarZyTheme.red, width: 1.2),
            todayForegroundColor: const WidgetStatePropertyAll(CarZyTheme.red),

            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return CarZyTheme.red;
              return Colors.transparent;
            }),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              return CarZyTheme.textDark;
            }),

            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return CarZyTheme.red;
              return Colors.transparent;
            }),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              return CarZyTheme.textDark;
            }),
          ),
        );

        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      controller.text = _dateFmt.format(picked);
      setState(() {});
    }
  }

  // ---- UI helpers ----
  InputDecoration _figmaDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: CarZyTheme.muted,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0x11000000)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0x11000000)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: CarZyTheme.red, width: 1.2),
      ),
      suffixIcon: suffix,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: CarZyTheme.muted,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingBooking != null;

    return BlocProvider(
      create: (_) => BookingCubit(repo: BookingRepository()),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFD), // ✅ lighter than bg
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBFBFD),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'choose_date'.tr(),
            style: const TextStyle(
              color: CarZyTheme.textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: CarZyTheme.textDark),
              ),
            ),
          ),
        ),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.tr())),
              );

            }
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.tr())),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingSuccessScreen(car: widget.car),
                ),
              );
              return;
            }
          },
          builder: (context, state) {
            final loading = state is BookingLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('pickup_location'.tr()),
                    TextFormField(
                      controller: _pickupLocation,
                      decoration: _figmaDecoration(
                        hint: 'pickup_hint'.tr(),
                        suffix: const Icon(Icons.location_on_outlined, color: CarZyTheme.muted),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                    ),

                    const SizedBox(height: 14),

                    _label('dropoff_location'.tr()),
                    TextFormField(
                      controller: _dropoffLocation,
                      decoration: _figmaDecoration(
                        hint: 'dropoff_hint'.tr(),
                        suffix: const Icon(Icons.location_on_outlined, color: CarZyTheme.muted),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('pickup_date'.tr()),
                              TextFormField(
                                controller: _pickupDate,
                                readOnly: true,
                                onTap: () => _pickDate(controller: _pickupDate),
                                decoration: _figmaDecoration(
                                  hint: 'enter_date'.tr(),
                                  suffix: const Icon(Icons.calendar_month_outlined, color: CarZyTheme.muted),
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('dropoff_date'.tr()),
                              TextFormField(
                                controller: _dropoffDate,
                                readOnly: true,
                                onTap: () {
                                  final start = _parseDateOnly(_pickupDate.text);
                                  _pickDate(
                                    controller: _dropoffDate,
                                    firstDate: start ?? DateTime.now(),
                                    initialDate: start != null ? start.add(const Duration(days: 1)) : null,
                                  );
                                },
                                decoration: _figmaDecoration(
                                  hint: 'enter_date'.tr(),
                                  suffix: const Icon(Icons.calendar_month_outlined, color: CarZyTheme.muted),
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarZyTheme.red, // ✅ red button
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: loading
                            ? null
                            : () {

                          if (!_formKey.currentState!.validate()) return;

                          final req = BookingRequest(
                            carId: widget.car.id,
                            pickupLocation: _pickupLocation.text.trim(),
                            dropoffLocation: _dropoffLocation.text.trim(),
                            pickupDate: _pickupDate.text.trim(),
                            dropoffDate: _dropoffDate.text.trim(),
                          );

                          final cubit = context.read<BookingCubit>();
                          if (isEdit) {
                            cubit.updateBooking(widget.existingBooking!.id, req);
                          } else {
                            cubit.createBooking(req);
                          }
                        },
                        child: loading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Text(
                          isEdit ? 'save'.tr() : 'continue'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
