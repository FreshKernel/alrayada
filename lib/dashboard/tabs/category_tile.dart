import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/presentation/widgets/my_image.dart';
import '../../products/data/category/product_category.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    super.key,
  });

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: GridTile(
          footer: GridTileBar(
            title: Text(category.name),
            backgroundColor: Colors.black54,
          ),
          child: MyImage(
            imageProvider: CachedNetworkImageProvider(category.imageUrls.first),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
