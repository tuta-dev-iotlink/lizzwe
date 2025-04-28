import 'package:flutter/foundation.dart';

/// A class that represents an observable value of type [T].
/// It notifies listeners when the value changes.
class Observable<T> extends ChangeNotifier {
  T _value;

  /// Creates an [Observable] with the given initial [value].
  Observable(this._value);

  /// The current value.
  T get value => _value;

  /// Updates the value and notifies listeners if the value has changed.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Updates the value without notifying listeners.
  void silentUpdate(T newValue) {
    _value = newValue;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
