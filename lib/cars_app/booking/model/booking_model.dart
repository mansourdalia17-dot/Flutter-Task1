import 'package:studio_project/cars_app/cars/model/car_model.dart';

class BookingModel {
  final int id;
  final int carId;

  final String? pickupLocation;
  final String? dropoffLocation;
  final String? pickupDate;
  final String? dropoffDate;

  final int? days;
  final double? totalPrice;
  final CarModel? car;

  const BookingModel({
    required this.id,
    required this.carId,
    this.pickupLocation,
    this.dropoffLocation,
    this.pickupDate,
    this.dropoffDate,
    this.days,
    this.totalPrice,
    this.car,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v, int fallback) {
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? fallback;
    }

    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse('$v');
    }

    final carJson = json['car'];

    return BookingModel(
      id: _toInt(json['id'], 0),
      carId: _toInt(json['carId'] ?? json['car_id'], 0),

      // ✅ accept both styles
      pickupLocation: (json['pickUpLocation'] ?? json['pickupLocation'])?.toString(),
      dropoffLocation: (json['dropOffLocation'] ?? json['dropoffLocation'])?.toString(),
      pickupDate: (json['pickUpDate'] ?? json['pickupDate'])?.toString(),
      dropoffDate: (json['dropOffDate'] ?? json['dropoffDate'])?.toString(),

      days: (json['days'] is num) ? (json['days'] as num).toInt() : int.tryParse('${json['days']}'),
      totalPrice: _toDouble(json['totalPrice']),
      car: (carJson is Map) ? CarModel.fromJson(Map<String, dynamic>.from(carJson)) : null,
    );
  }
}
