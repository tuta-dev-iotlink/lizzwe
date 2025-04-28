import 'observable.dart';

/// A store that manages multiple [Observable] instances.
class StateStore {
  final List<Observable<dynamic>> _observables = [];

  /// Creates a new [Observable] with the given [initialValue].
  Observable<T> create<T>(T initialValue) {
    final observable = Observable<T>(initialValue);
    _observables.add(observable);
    return observable;
  }

  /// Removes all observables from the store and disposes them.
  void clear() {
    for (final observable in _observables) {
      observable.dispose();
    }
    _observables.clear();
  }
}
