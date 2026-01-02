import 'package:studio_project/cars_app/cars/model/car_model.dart';

abstract class CarsState {
  const CarsState();
}

class CarsInitial extends CarsState {
  const CarsInitial();
}

class CarsLoading extends CarsState {
  const CarsLoading();
}

class CarsFailure extends CarsState {
  final String message;
  const CarsFailure(this.message);
}

class CarsLoaded extends CarsState {
  final List<CarModel> allCars; // full list
  final List<CarModel> cars; // filtered/sorted list for UI

  final String? selectedCity; // ✅ officeLocation (city) from API
  final int? minYear;
  final bool priceAsc;

  const CarsLoaded({
    required this.allCars,
    required this.cars,
    required this.selectedCity,
    required this.minYear,
    required this.priceAsc,
  });

  CarsLoaded copyWith({
    List<CarModel>? allCars,
    List<CarModel>? cars,
    String? selectedCity,
    int? minYear,
    bool? priceAsc,
  }) {
    return CarsLoaded(
      allCars: allCars ?? this.allCars,
      cars: cars ?? this.cars,
      selectedCity: selectedCity,
      minYear: minYear ?? this.minYear,
      priceAsc: priceAsc ?? this.priceAsc,
    );
  }
}
