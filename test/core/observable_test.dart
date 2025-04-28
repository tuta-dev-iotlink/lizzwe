import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';

void main() {
  group('Observable', () {
    late Observable<int> observable;
    int? lastValue;
    int notificationCount = 0;

    setUp(() {
      observable = Observable(0);
      lastValue = null;
      notificationCount = 0;

      observable.addListener(() {
        notificationCount++;
        lastValue = observable.value;
      });
    });

    test('should notify listeners when value changes', () {
      observable.value = 1;
      expect(lastValue, 1);
      expect(notificationCount, 1);
    });

    test('should not notify when value is the same', () {
      observable.value = 0;
      expect(notificationCount, 0);
    });

    test('should handle multiple listeners', () {
      int secondListenerCount = 0;
      observable.addListener(() => secondListenerCount++);

      observable.value = 1;
      expect(notificationCount, 1);
      expect(secondListenerCount, 1);
    });

    test('should not notify after dispose', () {
      observable.dispose();
      expect(() => observable.value = 1, throwsA(isA<StateError>()));
      expect(notificationCount, 0);
    });

    test('should handle async updates', () async {
      await observable.updateAsync((current) async {
        await Future.delayed(Duration(milliseconds: 100));
        return current + 1;
      });

      expect(observable.value, 1);
      expect(notificationCount, greaterThan(0));
    });

    test('should handle errors in async updates', () async {
      await expectLater(
        observable.updateAsync((_) async {
          await Future.delayed(Duration(milliseconds: 100));
          throw Exception('Test error');
        }),
        throwsException,
      );

      expect(observable.error, isA<Exception>());
    });

    test('should handle sync updates with callback', () {
      observable.update((current) => current + 1);
      expect(observable.value, 1);
      expect(notificationCount, 1);
    });

    test('should handle errors in sync updates', () {
      expect(
        () => observable.update((_) => throw Exception('Test error')),
        throwsException,
      );

      expect(observable.error, isA<Exception>());
    });

    test('should handle silent updates', () {
      observable.silentUpdate(1);
      expect(observable.value, 1);
      expect(notificationCount, 0);
    });
  });
}

class User {
  final String name;
  User(this.name);
}
