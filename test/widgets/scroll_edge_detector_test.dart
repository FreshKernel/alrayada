import 'package:alrayada/common/presentation/widgets/scroll_edge_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScrollEdgeDetector', () {
    var onTopCalled = false;
    var onBottomCalled = false;

    setUp(() {
      onTopCalled = false;
      onBottomCalled = false;
    });

    Widget testWidget() {
      return MaterialApp(
        home: ScrollEdgeDetector(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => SizedBox(
              height: 100,
              child: Text('Item $index'),
            ),
          ),
          onTop: () => onTopCalled = true,
          onBottom: () => onBottomCalled = true,
        ),
      );
    }

    // onTop tests
    testWidgets('should call onTop when scrolled to the top', (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling to the top
      await tester.fling(find.byType(ListView), const Offset(0, 100), 1000);

      // Verify that onTop is called
      expect(onTopCalled, true);
    });

    testWidgets('should not call onTop when not scrolling to the top edge',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling in the middle
      await tester.fling(find.byType(ListView), const Offset(0, -100), 1000);

      // Verify that callback are not called
      expect(onTopCalled, false);
    });

    // onBottom tests

    testWidgets('should call onBottom when scrolled to the bottom',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling to the bottom
      await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);

      // Verify that onBottom is called
      expect(onBottomCalled, true);
    });

    testWidgets(
        'should not call onBottom when not scrolling to the bottom edge',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling in the middle
      await tester.fling(find.byType(ListView), const Offset(0, 50), 1000);

      // Verify that callback are not called
      expect(onBottomCalled, false);
    });

    // onBottom and onTop tests
    testWidgets(
        'should call both onBottom and onTop when scrolling to the bottom and the top edge',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling to the top
      await tester.fling(find.byType(ListView), const Offset(0, 100), 1000);

      // Simulate scrolling to the bottom
      await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);

      // Verify that callbacks are called
      expect(onBottomCalled, true);
      expect(onTopCalled, true);
    });

    testWidgets(
        'should only call onBottom and not onTop when scrolling to the bottom edge',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling to the bottom
      await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);

      // Verify that callbacks are called
      expect(onBottomCalled, true);
      expect(onTopCalled, false);
    });

    testWidgets(
        'should only call onTop and not onBottom when scrolling to the top edge',
        (tester) async {
      await tester.pumpWidget(
        testWidget(),
      );

      // Simulate scrolling to the top
      await tester.fling(find.byType(ListView), const Offset(0, 100), 1000);

      // Verify that callbacks are called
      expect(onBottomCalled, false);
      expect(onTopCalled, true);
    });
  });
}
