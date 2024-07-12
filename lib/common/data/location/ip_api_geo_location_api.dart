import 'package:dio/dio.dart';

import '../../dio_service.dart';
import '../../extensions/dio_response_ext.dart';
import 'geo_location.dart';
import 'geo_location_api.dart';
import 'geo_location_exceptions.dart';

class IpApiGeoLocationApi implements GeoLocationApi {
  const IpApiGeoLocationApi();

  static const _url = 'https://ipapi.co/json';

  @override
  Future<GeoLocation> getLocation() async {
    try {
      final response =
          await DioService.instance.dio.get<Map<String, Object?>>(_url);
      return GeoLocation.fromJson(response.dataOrThrow);
    } on DioException catch (e) {
      throw UnknownGeoLocationException(message: e.message.toString());
    } catch (e) {
      throw UnknownGeoLocationException(message: e.toString());
    }
  }
}
