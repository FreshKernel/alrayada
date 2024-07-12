import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
sealed class ProductCategoryException extends Equatable implements Exception {
  const ProductCategoryException({required this.message});

  final String message;

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}

class UnknownProductCategoryException extends ProductCategoryException {
  const UnknownProductCategoryException({required super.message});
}
