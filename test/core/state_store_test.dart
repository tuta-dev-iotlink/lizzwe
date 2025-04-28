import 'package:flutter_test/flutter_test.dart';
import 'package:lizzwe/src/core/state_store.dart';

void main() {
  group('StateStore', () {
    late StateStore store;

    setUp(() {
      store = StateStore();
    });

    test('should create and get observable', () {
      final counter = store.create('counter', 0);
      expect(counter.value, 0);

      final sameCounter = store.get<int>('counter');
      expect(sameCounter, counter);
      expect(sameCounter.value, 0);
    });

    test('should throw when getting non-existent observable', () {
      expect(
        () => store.get<int>('non-existent'),
        throwsA(isA<StateError>()),
      );
    });

    test('should throw when creating duplicate observable', () {
      store.create('counter', 0);
      expect(
        () => store.create('counter', 1),
        throwsA(isA<StateError>()),
      );
    });

    test('should handle multiple observables', () {
      final counter = store.create('counter', 0);
      final name = store.create('name', 'test');
      final isLoading = store.create('loading', false);

      expect(counter.value, 0);
      expect(name.value, 'test');
      expect(isLoading.value, false);

      counter.value = 1;
      name.value = 'updated';
      isLoading.value = true;

      expect(store.get<int>('counter').value, 1);
      expect(store.get<String>('name').value, 'updated');
      expect(store.get<bool>('loading').value, true);
    });

    test('should handle null values', () {
      final nullableCounter = store.create<int?>('nullableCounter', null);
      expect(nullableCounter.value, null);

      nullableCounter.value = 1;
      expect(store.get<int?>('nullableCounter').value, 1);

      nullableCounter.value = null;
      expect(store.get<int?>('nullableCounter').value, null);
    });

    test('should maintain type safety', () {
      store.create('counter', 0);

      expect(
        () => store.get<String>('counter'),
        throwsA(isA<TypeError>()),
      );
    });

    test('should clear all observables', () {
      store.create('counter', 0);
      store.create('name', 'test');

      store.clear();

      expect(
        () => store.get<int>('counter'),
        throwsA(isA<StateError>()),
      );
      expect(
        () => store.get<String>('name'),
        throwsA(isA<StateError>()),
      );
    });

    test('should remove single observable', () {
      store.create('counter', 0);
      store.create('name', 'test');

      store.remove('counter');

      expect(
        () => store.get<int>('counter'),
        throwsA(isA<StateError>()),
      );
      expect(store.get<String>('name').value, 'test');
    });

    test('should check if observable exists', () {
      store.create('counter', 0);

      expect(store.has('counter'), true);
      expect(store.has('non-existent'), false);
    });
  });
}
