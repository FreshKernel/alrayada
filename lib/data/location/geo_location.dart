import 'dart:convert' show jsonEncode;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'geo_location.g.dart';

@immutable
@JsonSerializable()
class GeoLocation {
  const GeoLocation({
    // required String ip,
    // required String network,
    // required String version,
    required this.city,
    // required String region,
    // @JsonValue('region_code') required String regionCode,
    // required String country,
    // @JsonValue('country_name') required String countryName,
    // @JsonValue('country_code') required String countryCode,
    // @JsonValue('country_code_iso3') required String countryCodeIso3,
    // @JsonValue('country_capital') required String countryCapital,
    // @JsonValue('country_tld') required String countryTld,
    // @JsonValue('continent_code') required String continentCode,
    // @JsonValue('in_eu') required bool inEu,
    // String? postal,
    // required double latitude,
    // required double longitude,
    // required String timezone,
    // @JsonValue('utc_offset') required String utcOffset,
    // @JsonValue('country_calling_code') required String countryCallingCode,
    // required String currency,
    // @JsonValue('currency_name') required String currencyName,
    // required String languages,
    // @JsonValue('country_area') required double countryArea,
    // @JsonValue('country_population') required int countryPopulation,
    // required String asn,
    // required String org,
  });

  factory GeoLocation.fromJson(Map<String, Object?> json) =>
      _$GeoLocationFromJson(json);

  Map<String, Object?> toJson() => _$GeoLocationToJson(this);

  final String city;

  @override
  String toString() => jsonEncode(toJson());
}
