import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_project/cars_app/booking/data/booking_repository.dart';
import 'package:studio_project/cars_app/booking/state/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final BookingRepository repo;

  MyBookingsCubit({required this.repo}) : super(const MyBookingsInitial());

  Future<void> loadMyBookings() async {
    emit(const MyBookingsLoading());
    try {
      final items = await repo.fetchMyBookings();
      emit(MyBookingsLoaded(items));
    } catch (e) {
      emit(MyBookingsFailure(_cleanError(e)));
    }
  }

  Future<void> deleteAndRefresh(int bookingId) async {
    try {
      await repo.deleteBooking(bookingId);
      await loadMyBookings();
    } catch (e) {
      emit(MyBookingsFailure(_cleanError(e)));
    }
  }

  String _cleanError(Object e) {
    final s = e.toString();
    return s.replaceFirst('Exception: ', '').replaceFirst('Error: ', '').trim();
  }
}
