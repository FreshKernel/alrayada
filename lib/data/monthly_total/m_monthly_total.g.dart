// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_monthly_total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyTotalImpl _$$MonthlyTotalImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyTotalImpl(
      month: json['month'] as int,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$MonthlyTotalImplToJson(_$MonthlyTotalImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total': instance.total,
    };
