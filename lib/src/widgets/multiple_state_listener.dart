import 'package:flutter/material.dart';
import '../core/observable.dart';

/// A widget that listens to changes in multiple [Observable] instances and calls a listener callback.
class MultipleStateListener extends StatefulWidget {
  /// The map of observable values to listen to, with their keys.
  final Map<String, Observable<dynamic>> observables;

  /// The callback function that is called when any value changes.
  final void Function(Map<String, dynamic> values) listener;

  /// The child widget to display.
  final Widget child;

  /// Optional callback that determines whether the listener should be called.
  final bool Function(
      Map<String, dynamic> previous, Map<String, dynamic> current)? buildWhen;

  /// Creates a [MultipleStateListener] widget.
  ///
  /// The [observables], [listener], and [child] arguments must not be null.
  const MultipleStateListener({
    Key? key,
    required this.observables,
    required this.listener,
    required this.child,
    this.buildWhen,
  }) : super(key: key);

  @override
  State<MultipleStateListener> createState() => _MultipleStateListenerState();
}

class _MultipleStateListenerState extends State<MultipleStateListener> {
  late Map<String, dynamic> _previousValues;

  @override
  void initState() {
    super.initState();
    _previousValues = _getCurrentValues();
    _addListeners();
    // Call listener with initial values
    widget.listener(_previousValues);
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  void _addListeners() {
    for (final entry in widget.observables.entries) {
      entry.value.addListener(_handleChange);
    }
  }

  void _removeListeners() {
    for (final entry in widget.observables.entries) {
      entry.value.removeListener(_handleChange);
    }
  }

  Map<String, dynamic> _getCurrentValues() {
    return Map.fromEntries(
      widget.observables.entries.map(
        (entry) => MapEntry(entry.key, entry.value.value),
      ),
    );
  }

  void _handleChange() {
    final currentValues = _getCurrentValues();
    final shouldCallListener =
        widget.buildWhen?.call(_previousValues, currentValues) ?? true;

    if (shouldCallListener) {
      widget.listener(currentValues);
      _previousValues = currentValues;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
