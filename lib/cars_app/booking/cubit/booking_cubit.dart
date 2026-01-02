import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_project/cars_app/booking/data/booking_repository.dart';
import 'package:studio_project/cars_app/booking/model/booking_request_model.dart';
import 'package:studio_project/cars_app/booking/state/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repo;

  BookingCubit({required this.repo}) : super(const BookingInitial());

  Future<void> createBooking(BookingRequest req) async {
    emit(const BookingLoading());
    try {
      await repo.createBooking(req);
      emit(const BookingSuccess('Booking is created successfully'));
    } catch (e) {
      emit(BookingFailure(_cleanError(e)));
    }
  }

  Future<void> updateBooking(int bookingId, BookingRequest req) async {
    emit(const BookingLoading());
    try {
      await repo.updateBooking(bookingId, req);
      emit(const BookingSuccess('Booking is updated successfully'));
    } catch (e) {
      emit(BookingFailure(_cleanError(e)));
    }
  }

  String _cleanError(Object e) {
    // Most Dart exceptions print like: "Exception: message"
    final s = e.toString();
    return s.replaceFirst('Exception: ', '').replaceFirst('Error: ', '').trim();
  }
}
