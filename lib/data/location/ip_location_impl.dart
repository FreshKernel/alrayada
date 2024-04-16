import 'package:dio/dio.dart';

import '../../services/dio_service.dart';
import '../../utils/extensions/dio_response_ext.dart';
import 'geo_location.dart';
import 'location_repository.dart';

class IpLocationImpl implements LocationRepository {
  const IpLocationImpl();

  static const _url = 'https://ipapi.co/json';

  @override
  Future<GeoLocation> getLocation() async {
    try {
      final response =
          await DioService.instance.dio.get<Map<String, Object?>>(_url);
      final geoLocation = GeoLocation.fromJson(response.dataOrThrow);
      return geoLocation;
    } on DioException catch (e) {
      throw GeoLocationException(e.message.toString());
    } catch (e) {
      throw GeoLocationException(e.toString());
    }
  }
}
