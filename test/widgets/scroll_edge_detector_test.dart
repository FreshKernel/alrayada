import 'package:alrayada/widgets/scroll_edge_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScrollEdgeDetector', () {
    testWidgets('should call onTop when scrolled to the top', (tester) async {
      var onTopCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ScrollEdgeDetector(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
            onTop: () => onTopCalled = true,
          ),
        ),
      );

      // Simulate scrolling to the top
      await tester.fling(find.byType(ListView), const Offset(0, 100), 1000);

      // Verify that onTop is called
      expect(onTopCalled, true);
    });

    testWidgets('should not call onTop when not scrolling to the bottom edge',
        (tester) async {
      var onBottomCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ScrollEdgeDetector(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
            onBottom: () => onBottomCalled = true,
          ),
        ),
      );

      // Simulate scrolling in the middle
      await tester.fling(find.byType(ListView), const Offset(0, 50), 1000);

      // Verify that callbacks are not called
      expect(onBottomCalled, false);
    });
  });
}
