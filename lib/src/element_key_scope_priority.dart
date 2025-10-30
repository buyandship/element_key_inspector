/// Defines priority levels for [ElementKeyScope].
///
/// When multiple scopes are active, only the scopes with the highest priority
/// will be used for element key inspection. This allows fine-grained control
/// over which widget hierarchies are monitored.
class ElementKeyScopePriority {
  /// Highest priority level (3).
  static const int top = 3;

  /// High priority level (2).
  static const int high = 2;

  /// Normal/default priority level (1).
  static const int normal = 1;

  /// Lowest priority level (0).
  static const int low = 0;
}
