import 'geo_location.dart';

abstract class GeoLocationApi {
  Future<GeoLocation> getLocation();
}
