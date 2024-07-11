import 'package:flutter/material.dart';

// TODO: The widget behavior is not like I expexted it to be
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
        final isTopEdge = scrollEnd.metrics.pixels == 0;
        if (isTopEdge) {
          onTop?.call();
        } else {
          onBottom?.call();
        }
        return true;
      },
      child: child,
    );
  }
}
