import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/observable.dart';

void main() {
  group('Observable', () {
    late Observable<int> observable;

    setUp(() {
      observable = Observable<int>(0);
    });

    test('should initialize with initial value', () {
      expect(observable.value, equals(0));
    });

    test('should notify listeners when value changes', () {
      var notified = false;
      observable.addListener(() {
        notified = true;
      });

      observable.value = 1;
      expect(notified, isTrue);
      expect(observable.value, equals(1));
    });

    test('should not notify when value does not change', () {
      var notified = false;
      observable.addListener(() {
        notified = true;
      });

      observable.value = 0;
      expect(notified, isFalse);
    });

    test('should handle multiple listeners', () {
      var notified1 = false;
      var notified2 = false;

      observable.addListener(() {
        notified1 = true;
      });
      observable.addListener(() {
        notified2 = true;
      });

      observable.value = 1;
      expect(notified1, isTrue);
      expect(notified2, isTrue);
    });

    test('should not notify after dispose', () {
      var notified = false;
      observable.addListener(() {
        notified = true;
      });

      observable.dispose();
      expect(() => observable.value = 1, throwsFlutterError);
      expect(notified, isFalse);
    });

    test('should handle null values', () {
      final nullableObservable = Observable<String?>(null);
      expect(nullableObservable.value, isNull);

      nullableObservable.value = 'test';
      expect(nullableObservable.value, equals('test'));
    });

    test('should handle custom objects', () {
      final userObservable = Observable<User>(User('John'));
      expect(userObservable.value.name, equals('John'));

      userObservable.value = User('Jane');
      expect(userObservable.value.name, equals('Jane'));
    });

    test('should handle silent update', () {
      var notified = false;
      observable.addListener(() {
        notified = true;
      });

      observable.silentUpdate(1);
      expect(notified, isFalse);
      expect(observable.value, equals(1));
    });
  });
}

class User {
  final String name;
  User(this.name);
}
