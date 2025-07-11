import 'element_key_scope_priority.dart';

/// [type] the scope at the widget
/// [priority] the priority of the scope
/// [visibleCondition] the condition of the scope
/// EX:
/// ```dart
/// ElementKeyScope(
///   type: MyWidget,
///   priority: ElementKeyScopePriority.high,
///   visibleCondition: () => true,
/// );
/// ```
class ElementKeyScope {
  final Type type;
  final int priority;
  final bool Function()? visibleCondition;

  const ElementKeyScope({
    required this.type,
    this.priority = ElementKeyScopePriority.normal,
    this.visibleCondition,
  });

  @override
  String toString() {
    return 'ElementKeyScope{priority: $priority, type: $type, visibleCondition: $visibleCondition}';
  }
}
