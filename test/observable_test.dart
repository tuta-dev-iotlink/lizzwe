import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';

void main() {
  group('Observable Tests', () {
    late Observable<int> observable;

    setUp(() {
      observable = Observable<int>(0);
    });

    test('initial value is set correctly', () {
      expect(observable.value, equals(0));
    });

    test('value setter updates value and notifies listeners', () {
      var notified = false;
      observable.addListener(() => notified = true);

      observable.value = 1;

      expect(observable.value, equals(1));
      expect(notified, isTrue);
    });

    test('silentUpdate updates value without notifying', () {
      var notified = false;
      observable.addListener(() => notified = true);

      observable.silentUpdate(1);

      expect(observable.value, equals(1));
      expect(notified, isFalse);
    });

    test('update method handles synchronous operations', () {
      observable.update((current) => current + 1);
      expect(observable.value, equals(1));
    });

    test('update method handles errors', () {
      expect(
        () => observable.update((_) => throw Exception('Test error')),
        throwsException,
      );
    });

    test('updateAsync method handles asynchronous operations', () async {
      await observable.updateAsync((current) async {
        await Future.delayed(Duration(milliseconds: 100));
        return current + 1;
      });

      expect(observable.value, equals(1));
    });

    test('updateAsync handles errors', () async {
      expect(
        () => observable.updateAsync((_) async {
          await Future.delayed(Duration(milliseconds: 100));
          throw Exception('Test error');
        }),
        throwsException,
      );
    });

    test('updateAsync prevents concurrent operations', () async {
      var operationCount = 0;

      // Start first async operation
      final future1 = observable.updateAsync((current) async {
        await Future.delayed(Duration(milliseconds: 200));
        operationCount++;
        return current + 1;
      });

      // Try to start second operation while first is running
      final future2 = observable.updateAsync((current) async {
        await Future.delayed(Duration(milliseconds: 100));
        operationCount++;
        return current + 1;
      });

      await future1;
      await future2;

      expect(operationCount, equals(1));
      expect(observable.value, equals(1));
    });
  });
}
