import 'element_key_scope_priority.dart';

/// Defines a scope for element key inspection within a specific widget type.
///
/// An [ElementKeyScope] specifies which widget types should be monitored for element keys
/// and their inspection priority. Higher priority scopes take precedence when multiple
/// scopes are active.
///
/// Parameters:
/// - [type] - The widget type to monitor for element keys
/// - [priority] - The priority level (see [ElementKeyScopePriority])
/// - [visibleCondition] - Optional function to determine if this scope is currently active
///
/// Example:
/// ```dart
/// ElementKeyScope(
///   type: MyWidget,
///   priority: ElementKeyScopePriority.high,
///   visibleCondition: () => true,
/// );
/// ```
class ElementKeyScope {
  /// The widget type to monitor for element keys.
  final Type type;

  /// The priority level of this scope.
  final int priority;

  /// Optional function to determine if this scope is currently active.
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
