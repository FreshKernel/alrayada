import 'package:flutter/material.dart';

import '../data/category/product_category.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({
    required this.category,
    super.key,
  });

  static const routeName = '/categoryDetails';

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: const SafeArea(
        child: Text('Hi'),
      ),
    );
  }
}
