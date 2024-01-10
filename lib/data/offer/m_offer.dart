import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_offer.g.dart';
part 'm_offer.freezed.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String imageUrl,
    required DateTime createdAt,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
