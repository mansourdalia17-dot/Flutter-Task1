class ApiConfig {
  static const String baseUrl = 'http://localhost:5159';
  static const String apiPrefix = '/api';

  static const String registerEndpoint = '$apiPrefix/Auth/register';
  static const String loginEndpoint = '$apiPrefix/Auth/login';

  static const String carsAvailable = '$apiPrefix/CarsApi/available';
  static const String carsByPrice = '$apiPrefix/CarsApi/available/byprice';
  static const String carsByYear = '$apiPrefix/CarsApi/available/byyear';
  static const String carsByCity = '$apiPrefix/CarsApi/available/bycity';

  static const String bookings = '$apiPrefix/Bookings';
  static const String myBookings = '$apiPrefix/Bookings/my';

  static String url(String path) {
    final s = path.trim();
    if (s.startsWith('http://') || s.startsWith('https://')) return s;

    final b = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final p = s.startsWith('/') ? s : '/$s';
    return '$b$p';
  }

  static Uri uri(String path) => Uri.parse(url(path));
}
