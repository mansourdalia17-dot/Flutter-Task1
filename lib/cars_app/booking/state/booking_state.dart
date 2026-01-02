sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  final String message;
  const BookingSuccess(this.message);
}

class BookingFailure extends BookingState {
  final String message;
  const BookingFailure(this.message);
}
