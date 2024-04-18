import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:shared_preferences/shared_preferences.dart';

import 'geo_location.dart';
import 'ip_location_impl.dart';
import 'location_repository.dart';

class GeoLocationService implements LocationRepository {
  const GeoLocationService._();
  static const instance = GeoLocationService._();

  final LocationRepository _impl = const IpLocationImpl();

  @override
  Future<GeoLocation> getLocation() async {
    final geoLocation = await _impl.getLocation();
    await _saveCachedIpLocation(geoLocation);
    return geoLocation;
  }

  static const _locationKeyPrefKey = 'locationIp';

  Future<void> _saveCachedIpLocation(GeoLocation value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _locationKeyPrefKey,
      jsonEncode(value.toJson()),
    );
  }

  Future<GeoLocation?> getCachedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonValue = prefs.getString(_locationKeyPrefKey);
      if (jsonValue == null) return null;
      return GeoLocation.fromJson(jsonDecode(jsonValue));
    } catch (e) {
      throw GeoLocationException(e.toString());
    }
  }
}
