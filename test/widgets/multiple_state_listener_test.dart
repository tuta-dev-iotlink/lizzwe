import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';
import 'package:lizzwe/src/widgets/multiple_state_listener.dart';

void main() {
  group('MultipleStateListener', () {
    late Observable<int> counter1;
    late Observable<int> counter2;
    late Observable<String> name;
    late int listenerCallCount;
    late Map<String, dynamic> lastValues;

    setUp(() {
      counter1 = Observable<int>(0);
      counter2 = Observable<int>(0);
      name = Observable<String>('test');
      listenerCallCount = 0;
      lastValues = {};
    });

    testWidgets('should call listener on initial values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'counter1': counter1,
              'counter2': counter2,
              'name': name,
            },
            listener: (values) {
              listenerCallCount++;
              lastValues = values;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1);
      expect(lastValues['counter1'], 0);
      expect(lastValues['counter2'], 0);
      expect(lastValues['name'], 'test');
    });

    testWidgets('should call listener when any value changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'counter1': counter1,
              'counter2': counter2,
              'name': name,
            },
            listener: (values) {
              listenerCallCount++;
              lastValues = values;
            },
            child: const SizedBox(),
          ),
        ),
      );

      counter1.value = 1;
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(lastValues['counter1'], 1);
      expect(lastValues['counter2'], 0);
      expect(lastValues['name'], 'test');

      name.value = 'updated';
      await tester.pump();
      expect(listenerCallCount, 3);
      expect(lastValues['counter1'], 1);
      expect(lastValues['counter2'], 0);
      expect(lastValues['name'], 'updated');
    });

    testWidgets('should not call listener when buildWhen returns false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'counter1': counter1,
              'counter2': counter2,
            },
            buildWhen: (previous, current) {
              return current['counter1'] % 2 == 0;
            },
            listener: (values) {
              listenerCallCount++;
              lastValues = values;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1);

      counter1.value = 1; // Odd number, shouldn't call listener
      await tester.pump();
      expect(listenerCallCount, 1);

      counter1.value = 2; // Even number, should call listener
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(lastValues['counter1'], 2);
      expect(lastValues['counter2'], 0);
    });

    testWidgets('should handle child widget correctly', (tester) async {
      const childKey = Key('child');

      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'counter1': counter1,
            },
            listener: (values) {},
            child: const SizedBox(key: childKey),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('should dispose listeners when widget is removed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'counter1': counter1,
              'counter2': counter2,
            },
            listener: (values) {},
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Should not throw error when updating after dispose
      counter1.value = 1;
      counter2.value = 1;
    });

    testWidgets('should handle null values', (tester) async {
      final nullableCounter = Observable<int?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: MultipleStateListener(
            observables: {
              'nullableCounter': nullableCounter,
            },
            listener: (values) {
              listenerCallCount++;
              lastValues = values;
            },
            child: const SizedBox(),
          ),
        ),
      );

      expect(listenerCallCount, 1);
      expect(lastValues['nullableCounter'], null);

      nullableCounter.value = 1;
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(lastValues['nullableCounter'], 1);
    });
  });
}
