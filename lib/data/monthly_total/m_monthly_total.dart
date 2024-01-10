import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_monthly_total.freezed.dart';
part 'm_monthly_total.g.dart';

@freezed
class MonthlyTotal with _$MonthlyTotal {
  const factory MonthlyTotal({required int month, required double total}) =
      _MonthlyTotal;

  factory MonthlyTotal.fromJson(Map<String, dynamic> json) =>
      _$MonthlyTotalFromJson(json);
}
