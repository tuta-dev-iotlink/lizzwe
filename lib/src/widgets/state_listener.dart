import 'package:flutter/material.dart';
import '../core/observable.dart';

/// A widget that listens to changes in an [Observable] and calls a listener callback.
class StateListener<T> extends StatefulWidget {
  /// The observable value to listen to.
  final Observable<T> observable;

  /// The callback function that is called when the value changes.
  final void Function(T? previous, T current) listener;

  /// The child widget to display.
  final Widget child;

  /// Optional callback that determines whether the listener should be called.
  final bool Function(T previous, T current)? buildWhen;

  /// Creates a [StateListener] widget.
  ///
  /// The [observable], [listener], and [child] arguments must not be null.
  const StateListener({
    Key? key,
    required this.observable,
    required this.listener,
    required this.child,
    this.buildWhen,
  }) : super(key: key);

  @override
  State<StateListener<T>> createState() => _StateListenerState<T>();
}

class _StateListenerState<T> extends State<StateListener<T>> {
  late T _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.observable.value;
    widget.observable.addListener(_handleChange);
    // Call listener with initial value
    widget.listener(null, widget.observable.value);
  }

  @override
  void dispose() {
    widget.observable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    final currentValue = widget.observable.value;
    final shouldCallListener =
        widget.buildWhen?.call(_previousValue, currentValue) ?? true;

    if (shouldCallListener) {
      widget.listener(_previousValue, currentValue);
      _previousValue = currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
