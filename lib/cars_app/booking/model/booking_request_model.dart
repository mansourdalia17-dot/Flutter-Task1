class BookingRequest {
  final int carId;
  final String pickupLocation;
  final String dropoffLocation;
  final String pickupDate;
  final String dropoffDate;

  const BookingRequest({
    required this.carId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDate,
    required this.dropoffDate,
  });

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'pickupLocation': pickupLocation,
    'dropoffLocation': dropoffLocation,
    'pickupDate': pickupDate,
    'dropoffDate': dropoffDate,
  };
}
