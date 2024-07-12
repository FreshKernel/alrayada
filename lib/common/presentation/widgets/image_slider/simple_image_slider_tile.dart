import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../my_image.dart';

@immutable
class SimpleImageSliderItem {
  const SimpleImageSliderItem({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;
}

class SimpleImageSliderTile extends StatelessWidget {
  const SimpleImageSliderTile({required this.item, super.key});

  final SimpleImageSliderItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Stack(
        children: [
          MyImage(
            imageProvider: CachedNetworkImageProvider(item.imageUrl),
            fit: BoxFit.cover,
            width: 1000.0,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                item.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
