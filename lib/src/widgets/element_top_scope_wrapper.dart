import 'package:flutter/material.dart';

class ElementTopScopeWrapper extends StatelessWidget {
  final Widget child;

  const ElementTopScopeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
