import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';
import 'package:lizzwe/src/widgets/state_builder.dart';

void main() {
  group('StateBuilder', () {
    late Observable<int> counter;

    setUp(() {
      counter = Observable<int>(0);
    });

    testWidgets('should build with initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int>(
            observable: counter,
            builder: (context, value) => Text('Count: $value'),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('should rebuild when value changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int>(
            observable: counter,
            builder: (context, value) => Text('Count: $value'),
          ),
        ),
      );

      counter.value = 1;
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('should not rebuild when buildWhen returns false',
        (tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int>(
            observable: counter,
            buildWhen: (previous, current) => current % 2 == 0,
            builder: (context, value) {
              buildCount++;
              return Text('Count: $value');
            },
          ),
        ),
      );

      expect(buildCount, 1); // Initial build

      counter.value = 1; // Odd number, shouldn't rebuild
      await tester.pump();
      expect(buildCount, 1);

      counter.value = 2; // Even number, should rebuild
      await tester.pump();
      expect(buildCount, 2);
    });

    testWidgets('should handle child widget correctly', (tester) async {
      const childKey = Key('child');

      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int>(
            observable: counter,
            builder: (context, value) => Column(
              children: [
                Text('Count: $value'),
                const SizedBox(key: childKey),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);

      counter.value = 1;
      await tester.pump();

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('should dispose listeners when widget is removed',
        (tester) async {
      final observerKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int>(
            key: observerKey,
            observable: counter,
            builder: (context, value) => Text('Count: $value'),
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
          home: StateBuilder<int?>(
            observable: nullableCounter,
            builder: (context, value) => Text('Count: ${value ?? "null"}'),
          ),
        ),
      );

      expect(find.text('Count: null'), findsOneWidget);

      nullableCounter.value = 1;
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
