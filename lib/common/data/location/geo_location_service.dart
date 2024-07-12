import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:shared_preferences/shared_preferences.dart';

import 'geo_location.dart';
import 'geo_location_api.dart';
import 'geo_location_exceptions.dart';
import 'ip_api_geo_location_api.dart';

class GeoLocationService implements GeoLocationApi {
  const GeoLocationService._();
  static const instance = GeoLocationService._();

  final GeoLocationApi _geoLocationApi = const IpApiGeoLocationApi();

  @override
  Future<GeoLocation> getLocation() async {
    final location = await _geoLocationApi.getLocation();
    await _saveCachedIpLocation(location);
    return location;
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
      throw UnknownGeoLocationException(message: e.toString());
    }
  }
}
