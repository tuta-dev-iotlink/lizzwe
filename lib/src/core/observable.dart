import 'package:flutter/foundation.dart';

/// A class that represents an observable value of type [T].
/// It notifies listeners when the value changes.
class Observable<T> extends ChangeNotifier {
  T _value;
  bool _isLoading = false;
  Object? _error;

  /// Creates an [Observable] with the given initial [value].
  Observable(this._value);

  /// The current value.
  T get value => _value;

  /// Whether the observable is currently loading (for async operations)
  bool get isLoading => _isLoading;

  /// The current error, if any
  Object? get error => _error;

  /// Updates the value and notifies listeners if the value has changed.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _error = null;
      notifyListeners();
    }
  }

  /// Updates the value without notifying listeners.
  void silentUpdate(T newValue) {
    _value = newValue;
  }

  /// Updates the value synchronously using a callback
  /// Useful for complex synchronous operations
  void update(T Function(T current) updater) {
    try {
      final newValue = updater(_value);
      if (_value != newValue) {
        _value = newValue;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = e;
      notifyListeners();
      rethrow;
    }
  }

  /// Updates the value asynchronously using a Future
  /// Useful for API calls or other async operations
  Future<void> updateAsync(Future<T> Function(T current) updater) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newValue = await updater(_value);
      if (_value != newValue) {
        _value = newValue;
        notifyListeners();
      }
    } catch (e) {
      _error = e;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
