import 'package:flutter/foundation.dart';
import 'dart:async';

/// A class that represents an observable value of type [T].
/// It notifies listeners when the value changes.
class Observable<T> extends ChangeNotifier {
  T _value;
  bool _isLoading = false;
  Object? _error;
  bool _disposed = false;
  final _controller = StreamController<T>.broadcast();

  /// Creates an [Observable] with the given initial [value].
  Observable(this._value);

  /// The current value.
  T get value {
    if (_disposed) {
      throw StateError('Cannot access value of disposed Observable');
    }
    return _value;
  }

  /// Whether the observable is currently loading (for async operations)
  bool get isLoading => _isLoading;

  /// The current error, if any
  Object? get error => _error;

  /// Updates the value and notifies listeners if the value has changed.
  set value(T newValue) {
    if (_disposed) {
      throw StateError('Cannot set value of disposed Observable');
    }
    if (_value != newValue) {
      _value = newValue;
      _error = null;
      _controller.add(_value);
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
        _controller.add(_value);
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
        _controller.add(_value);
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

  /// Adds a listener that will be called whenever the value changes.
  void addValueListener(void Function(T) listener) {
    if (_disposed) {
      throw StateError('Cannot add listener to disposed Observable');
    }
    _controller.stream.listen(listener);
  }

  /// Disposes this observable, releasing any resources.
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _controller.close();
      super.dispose();
    }
  }
}
