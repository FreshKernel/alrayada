class Favorite {

  const Favorite({required this.productId, required this.createdAt});

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      productId: map['productId'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
  final String productId;
  final int createdAt;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'createdAt': createdAt,
    };
  }

  Favorite copyWith({
    String? productId,
    int? createdAt,
  }) {
    return Favorite(
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
