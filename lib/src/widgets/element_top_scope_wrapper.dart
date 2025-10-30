import 'package:flutter/material.dart';

/// A wrapper widget that can be used to define a top-level scope boundary
/// for element key inspection.
///
/// This widget simply wraps its [child] and serves as a marker in the widget
/// tree to define scope boundaries when used with [ElementKeyScope].
class ElementTopScopeWrapper extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Creates an [ElementTopScopeWrapper].
  const ElementTopScopeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
