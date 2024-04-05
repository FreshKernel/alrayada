import 'package:flutter/material.dart';

class ScrollEdgeDetector extends StatelessWidget {
  const ScrollEdgeDetector({
    required this.child,
    super.key,
    this.onBottom,
    this.onTop,
  });

  final Widget child;
  final VoidCallback? onBottom;
  final VoidCallback? onTop;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        if (!scrollEnd.metrics.atEdge) {
          return true;
        }
        final isTop = scrollEnd.metrics.pixels == 0;
        if (isTop) {
          onTop?.call();
          return true;
        }
        onBottom?.call();
        return true;
      },
      child: child,
    );
  }
}
