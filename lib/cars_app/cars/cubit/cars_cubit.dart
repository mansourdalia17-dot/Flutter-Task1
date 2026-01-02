import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_project/cars_app/booking/data/cars_reprository.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';
import 'package:studio_project/cars_app/cars/state/cars_state.dart';

class CarsCubit extends Cubit<CarsState> {
  final CarRepository repo;

  CarsCubit({required this.repo}) : super(const CarsInitial());

  Future<void> loadCars() async {
    emit(const CarsLoading());
    try {
      final all = await repo.fetchCars();

      // default: sort ascending by price
      final sorted = [...all]..sort((a, b) => _cmpPrice(a, b, asc: true));

      emit(CarsLoaded(
        allCars: all,
        cars: sorted,
        selectedCity: null, // ✅ officeLocation
        minYear: null,
        priceAsc: true,
      ));
    } catch (e) {
      emit(CarsFailure(e.toString()));
    }
  }

  Future<void> loadByCity(String? city) async {
    final s = state;
    if (s is! CarsLoaded) return;

    final filtered = _applyFilters(
      allCars: s.allCars,
      city: city, // ✅ officeLocation (city)
      minYear: s.minYear,
      priceAsc: s.priceAsc,
    );

    emit(s.copyWith(
      cars: filtered,
      selectedCity: city,
      minYear: s.minYear,
      priceAsc: s.priceAsc,
    ));
  }

  Future<void> loadByMinYear(int? minYear) async {
    final s = state;
    if (s is! CarsLoaded) return;

    final filtered = _applyFilters(
      allCars: s.allCars,
      city: s.selectedCity,
      minYear: minYear,
      priceAsc: s.priceAsc,
    );

    emit(s.copyWith(
      cars: filtered,
      selectedCity: s.selectedCity,
      minYear: minYear,
      priceAsc: s.priceAsc,
    ));
  }

  /// ✅ named parameter `asc` (matches your screen call)
  Future<void> loadByPrice({required bool asc}) async {
    final s = state;
    if (s is! CarsLoaded) return;

    final filtered = _applyFilters(
      allCars: s.allCars,
      city: s.selectedCity,
      minYear: s.minYear,
      priceAsc: asc,
    );

    emit(s.copyWith(
      cars: filtered,
      selectedCity: s.selectedCity,
      minYear: s.minYear,
      priceAsc: asc,
    ));
  }

  List<CarModel> _applyFilters({
    required List<CarModel> allCars,
    required String? city,
    required int? minYear,
    required bool priceAsc,
  }) {
    Iterable<CarModel> res = allCars;

    // ✅ Filter by officeLocation (city) coming from API
    if (city != null && city.trim().isNotEmpty) {
      final c = city.trim().toLowerCase();
      res = res.where((x) => (x.officeLocation ?? '').trim().toLowerCase() == c);
    }

    // ✅ Filter by year (carModel converted to year inside CarModel, or year field if you already have it)
    if (minYear != null) {
      res = res.where((x) => (x.year ?? 0) >= minYear);
    }

    final list = res.toList()
      ..sort((a, b) => _cmpPrice(a, b, asc: priceAsc));

    return list;
  }

  int _cmpPrice(CarModel a, CarModel b, {required bool asc}) {
    final ap = a.pricePerDay ?? 0;
    final bp = b.pricePerDay ?? 0;
    return asc ? ap.compareTo(bp) : bp.compareTo(ap);
  }
}
