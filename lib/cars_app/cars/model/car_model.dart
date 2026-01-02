class CarModel {
  final int id;
  final String name;
  final String model;
  final int? year;
  final double? pricePerDay;

  // city/location
  final String? officeLocation;
  final String? officeName;

  // image URL/path
  final String? image;

  // ✅ NEW: from API
  final int? capacity;
  final String? licensePlate;

  const CarModel({
    required this.id,
    required this.name,
    required this.model,
    this.year,
    this.pricePerDay,
    this.officeLocation,
    this.officeName,
    this.image,

    // ✅ NEW
    this.capacity,
    this.licensePlate,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    int? _asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString());
    }

    double? _asDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    String? _asString(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    // If API doesn't send "year", extract it from carModel like "2018"
    final carModelStr = (json['model'] ?? json['carModel'] ?? '').toString();
    final parsedYear =
        _asInt(json['year'] ?? json['carYear']) ?? int.tryParse(carModelStr);

    // ✅ capacity: support common API key names
    final parsedCapacity = _asInt(
      json['capacity'] ??
          json['seats'] ??
          json['seatCount'] ??
          json['passengers'] ??
          json['passengerCapacity'],
    );

    // ✅ license plate: support common API key names
    final parsedPlate = _asString(
      json['licensePlate'] ??
          json['licencePlate'] ??
          json['plateNumber'] ??
          json['plateNo'] ??
          json['registrationNumber'],
    );

    return CarModel(
      id: _asInt(json['id'] ?? json['carId']) ?? 0,
      name: (json['name'] ?? json['carName'] ?? '').toString(),
      model: carModelStr,
      year: parsedYear,
      pricePerDay:
      _asDouble(json['pricePerDay'] ?? json['price'] ?? json['dailyPrice']),
      officeLocation:
      _asString(json['officeLocation'] ?? json['city'] ?? json['location']),
      officeName: _asString(json['officeName'] ?? json['office'] ?? json['branch']),

      // ✅ Prefer imageUrl first (new API), then image (old), then photo
      image: _asString(json['imageUrl'] ?? json['image'] ?? json['photo']),

      // ✅ NEW
      capacity: parsedCapacity,
      licensePlate: parsedPlate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
      'pricePerDay': pricePerDay,
      'officeLocation': officeLocation,
      'officeName': officeName,

      // keep "image" for your app side
      'image': image,

      // ✅ NEW
      'capacity': capacity,
      'licensePlate': licensePlate,
    };
  }
}
