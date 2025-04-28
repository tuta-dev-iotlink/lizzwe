import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';
import 'package:lizzwe/src/widgets/state_listener.dart';

void main() {
  group('StateListener', () {
    late Observable<int> counter;
    late int listenerCallCount;
    late int? lastPreviousValue;
    late int? lastCurrentValue;

    setUp(() {
      counter = Observable<int>(0);
      listenerCallCount = 0;
      lastPreviousValue = null;
      lastCurrentValue = null;
    });

    testWidgets('should call listener on initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int>(
            observable: counter,
            listener: (previous, current) {
              listenerCallCount++;
              lastPreviousValue = previous;
              lastCurrentValue = current;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1);
      expect(lastPreviousValue, null);
      expect(lastCurrentValue, 0);
    });

    testWidgets('should call listener when value changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int>(
            observable: counter,
            listener: (previous, current) {
              listenerCallCount++;
              lastPreviousValue = previous;
              lastCurrentValue = current;
            },
            child: const SizedBox(),
          ),
        ),
      );

      counter.value = 1;
      await tester.pump();

      expect(listenerCallCount, 2);
      expect(lastPreviousValue, 0);
      expect(lastCurrentValue, 1);
    });

    testWidgets('should not call listener when buildWhen returns false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int>(
            observable: counter,
            buildWhen: (previous, current) => current % 2 == 0,
            listener: (previous, current) {
              listenerCallCount++;
              lastPreviousValue = previous;
              lastCurrentValue = current;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1); // Initial call

      counter.value = 1; // Odd number, shouldn't call listener
      await tester.pump();
      expect(listenerCallCount, 1);

      counter.value = 2; // Even number, should call listener
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(lastPreviousValue, 0);
      expect(lastCurrentValue, 2);
    });

    testWidgets('should handle child widget correctly', (tester) async {
      const childKey = Key('child');

      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int>(
            observable: counter,
            listener: (previous, current) {},
            child: const SizedBox(key: childKey),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('should dispose listeners when widget is removed',
        (tester) async {
      final observerKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int>(
            key: observerKey,
            observable: counter,
            listener: (previous, current) {},
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Should not throw error when updating after dispose
      counter.value = 1;
    });

    testWidgets('should handle null values', (tester) async {
      final nullableCounter = Observable<int?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: StateListener<int?>(
            observable: nullableCounter,
            listener: (previous, current) {
              listenerCallCount++;
              lastPreviousValue = previous;
              lastCurrentValue = current;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1);
      expect(lastPreviousValue, null);
      expect(lastCurrentValue, null);

      nullableCounter.value = 1;
      await tester.pump();

      expect(listenerCallCount, 2);
      expect(lastPreviousValue, null);
      expect(lastCurrentValue, 1);
    });
  });
}
