import 'package:studio_project/cars_app/booking/model/booking_model.dart';

sealed class MyBookingsState {
  const MyBookingsState();
}

class MyBookingsInitial extends MyBookingsState {
  const MyBookingsInitial();
}

class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingModel> items;
  const MyBookingsLoaded(this.items);
}

class MyBookingsFailure extends MyBookingsState {
  final String message;
  const MyBookingsFailure(this.message);
}
