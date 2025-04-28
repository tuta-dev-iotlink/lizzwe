import 'package:flutter/material.dart';
import '../core/observable.dart';

/// A widget that rebuilds its child when the [Observable] changes.
class StateBuilder<T> extends StatefulWidget {
  /// The observable value to listen to.
  final Observable<T> observable;

  /// The builder function that builds the widget tree based on the current value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional child widget that will be passed to the builder.
  final Widget? child;

  /// Optional callback that determines whether the widget should rebuild.
  final bool Function(T previous, T current)? buildWhen;

  /// Creates a [StateBuilder] widget.
  ///
  /// The [observable] and [builder] arguments must not be null.
  const StateBuilder({
    Key? key,
    required this.observable,
    required this.builder,
    this.child,
    this.buildWhen,
  }) : super(key: key);

  @override
  State<StateBuilder<T>> createState() => _StateBuilderState<T>();
}

class _StateBuilderState<T> extends State<StateBuilder<T>> {
  late T _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.observable.value;
    widget.observable.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.observable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    final currentValue = widget.observable.value;
    final shouldBuild =
        widget.buildWhen?.call(_previousValue, currentValue) ?? true;

    if (shouldBuild) {
      setState(() {
        _previousValue = currentValue;
      });
    } else {
      _previousValue = currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.observable.value);
  }
}
