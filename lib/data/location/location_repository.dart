import 'geo_location.dart';

class GeoLocationException implements Exception {
  GeoLocationException(this.message);
  final String message;

  @override
  String toString() => message.toString();
}

abstract class LocationRepository {
  Future<GeoLocation> getLocation();
}
