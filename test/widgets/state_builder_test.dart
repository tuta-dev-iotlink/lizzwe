import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';
import 'package:lizzwe/src/widgets/state_builder.dart';

void main() {
  group('StateBuilder', () {
    late Observable<int> counter;
    late int buildCount;

    setUp(() {
      counter = Observable<int>(0);
      buildCount = 0;
    });

    Widget buildTestWidget({bool Function(int, int)? buildWhen}) {
      return MaterialApp(
        home: StateBuilder<int>(
          observable: counter,
          buildWhen: buildWhen,
          builder: (context, value) {
            buildCount++;
            return Text(value.toString());
          },
        ),
      );
    }

    testWidgets('should build with initial value', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('0'), findsOneWidget);
      expect(buildCount, 1);
    });

    testWidgets('should rebuild when value changes', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(buildCount, 1);

      counter.value = 1;
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(buildCount, 2);
    });

    testWidgets('should not rebuild when buildWhen returns false',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          buildWhen: (previous, current) => current % 2 == 0,
        ),
      );
      expect(buildCount, 1);

      counter.value = 1; // Odd number, shouldn't rebuild
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
      expect(buildCount, 1);

      counter.value = 2; // Even number, should rebuild
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      expect(buildCount, 2);
    });

    testWidgets('should handle null values', (tester) async {
      final nullableCounter = Observable<int?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: StateBuilder<int?>(
            observable: nullableCounter,
            builder: (context, value) {
              buildCount++;
              return Text(value?.toString() ?? 'null');
            },
          ),
        ),
      );

      expect(find.text('null'), findsOneWidget);
      expect(buildCount, 1);

      nullableCounter.value = 1;
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(buildCount, 2);
    });

    testWidgets('should dispose listeners when widget is removed',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Should not throw error when updating after dispose
      counter.value = 1;
    });

    testWidgets('should rebuild only when value actually changes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(buildCount, 1);

      counter.value = 0; // Same value
      await tester.pump();
      expect(buildCount, 1); // Should not rebuild

      counter.value = 1; // Different value
      await tester.pump();
      expect(buildCount, 2); // Should rebuild
    });
  });
}
