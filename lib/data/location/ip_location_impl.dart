import 'package:dio/dio.dart';

import '../../services/dio_service.dart';
import 'geo_location.dart';
import 'location_repository.dart';

class IpLocationImpl implements LocationRepository {
  const IpLocationImpl();

  static const _url = 'https://ipapi.co/json';

  @override
  Future<GeoLocation> getLocation() async {
    try {
      final response =
          await DioService.instance.dio.get<Map<String, dynamic>>(_url);
      final responseData = response.data;
      if (responseData == null) {
        throw GeoLocationException('Response data is null');
      }
      final geoLocation = GeoLocation.fromJson(responseData);
      return geoLocation;
    } on DioException catch (e) {
      throw GeoLocationException(e.message.toString());
    } catch (e) {
      throw GeoLocationException(e.toString());
    }
  }
}
