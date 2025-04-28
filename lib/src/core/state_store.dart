import 'observable.dart';

/// A store that manages multiple [Observable] instances.
class StateStore {
  final Map<String, Observable<dynamic>> _observables = {};

  /// Creates a new [Observable] with the given [key] and [initialValue].
  ///
  /// Throws a [StateError] if an observable with the same key already exists.
  Observable<T> create<T>(String key, T initialValue) {
    if (_observables.containsKey(key)) {
      throw StateError('Observable with key "$key" already exists');
    }

    final observable = Observable<T>(initialValue);
    _observables[key] = observable;
    return observable;
  }

  /// Gets an existing [Observable] with the given [key].
  ///
  /// Throws a [StateError] if no observable exists with the given key.
  /// Throws a [TypeError] if the observable exists but has a different type.
  Observable<T> get<T>(String key) {
    final observable = _observables[key];
    if (observable == null) {
      throw StateError('No observable found with key "$key"');
    }

    // This cast will throw TypeError if the types don't match
    return observable as Observable<T>;
  }

  /// Checks if an observable with the given [key] exists.
  bool has(String key) => _observables.containsKey(key);

  /// Removes the observable with the given [key].
  void remove(String key) {
    _observables.remove(key);
  }

  /// Removes all observables from the store.
  void clear() {
    _observables.clear();
  }
}
