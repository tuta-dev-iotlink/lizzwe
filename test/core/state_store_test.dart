import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/state_store.dart';

void main() {
  group('StateStore', () {
    late StateStore store;

    setUp(() {
      store = StateStore();
    });

    test('should create observable with initial value', () {
      final counter = store.create(0);
      expect(counter.value, 0);
    });

    test('should handle multiple observables', () {
      final counter = store.create(0);
      final name = store.create('test');
      final isLoading = store.create(false);

      expect(counter.value, 0);
      expect(name.value, 'test');
      expect(isLoading.value, false);

      counter.value = 1;
      name.value = 'updated';
      isLoading.value = true;

      expect(counter.value, 1);
      expect(name.value, 'updated');
      expect(isLoading.value, true);
    });

    test('should handle null values', () {
      final nullableCounter = store.create<int?>(null);
      expect(nullableCounter.value, null);

      nullableCounter.value = 1;
      expect(nullableCounter.value, 1);

      nullableCounter.value = null;
      expect(nullableCounter.value, null);
    });

    test('should clear all observables', () {
      final counter = store.create(0);
      final name = store.create('test');

      store.clear();

      // After clear, observables should be disposed
      expect(() => counter.value, throwsA(isA<StateError>()));
      expect(() => name.value, throwsA(isA<StateError>()));
    });
  });
}
