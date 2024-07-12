import 'package:flutter/material.dart';

import 'errors/unknown_error.dart';

/// A image widget that share common code such as error handling and loading indiactor
class MyImage extends StatelessWidget {
  const MyImage({
    required this.imageProvider,
    this.fit,
    this.width,
    super.key,
  });

  final ImageProvider imageProvider;
  final BoxFit? fit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: imageProvider,
      errorBuilder: (context, error, stackTrace) =>
          const UnknownError(onTryAgain: null),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        final expectedTotalBytes = loadingProgress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator.adaptive(
            value: expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / expectedTotalBytes
                : null,
          ),
        );
      },
      fit: fit,
      width: width,
    );
  }
}
