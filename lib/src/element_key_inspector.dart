library element_key_inspector;

import 'package:flutter/material.dart';

import 'element_key_scope.dart';

class ElementKeyInspector {
  static final List<ElementKeyScope> _scopes = [];
  static bool Function(String)? _customElementKeyFormatChecker;

  /// Initialize the ElementKeyScope
  /// [scopes] the scopes of the element key
  /// [elementKeyFormatChecker] the custom element key format checker
  /// EX:
  /// ```dart
  /// ElementKeyInspector.initializeElementKeyScopes(
  ///   scopes: [
  ///     ElementKeyScope(type: MyWidget),
  ///   ],
  ///   elementKeyFormatChecker: (key) => key.startsWith('MyApp_'),
  /// );
  /// ```
  static void initialize({
    required List<ElementKeyScope> scopes,
    bool Function(String)? elementKeyPattern,
  }) {
    _scopes.addAll(scopes);
    _customElementKeyFormatChecker = elementKeyPattern;
  }

  /// Get all the element key positions by the scopes
  /// EX:
  /// ```dart
  /// final widgetPositions = ElementKeyInspector.getElementKeyPositions();
  /// ```
  static Map<String, Rect> getElementKeyPositions() {
    Map<String, Rect> widgetPositions = {};

    final Set<Type> activeParents = {};

    void findAllParents(Element element) {
      activeParents.add(element.widget.runtimeType);
      element.visitChildren(findAllParents);
    }

    // 收集目前 Widget 樹中所有的類型
    WidgetsBinding.instance.rootElement?.visitChildren(findAllParents);
    // 取得所有符合條件的 ElementKeyScope
    final visibleScopes = _scopes.where((s) => (s.visibleCondition?.call() ?? true) && activeParents.contains(s.type)).toList();

    if (visibleScopes.isEmpty) {
      return widgetPositions;
    }

    // 找出所有可見 scope 中優先權最高的值
    final highestPriority = visibleScopes.map((s) => s.priority).reduce((a, b) => a > b ? a : b);
    // 篩選出所有優先權等於最高值的 scope
    final highestScopes = visibleScopes.where((s) => s.priority == highestPriority).toList();
    // 取得這些最高優先權 scope 的型別集合
    final highestScopeNames = highestScopes.map((s) => s.type).toSet();

    final List<Type> parents = [];

    void findAllElements(Element element) {
      parents.add(element.widget.runtimeType);

      final isInsideHighestScope = highestScopeNames.any(parents.contains);
      final key = element.widget.key;
      if (key is ValueKey<String> && key.isElementKeyFormat && isInsideHighestScope) {
        if (element.renderObject case final RenderBox renderBox) {
          final Offset position = renderBox.localToGlobal(Offset.zero);
          final Rect bounds = renderBox.paintBounds.shift(position);
          widgetPositions[key.value] = bounds;
        }
      }

      element.visitChildren(findAllElements);
      parents.removeLast();
    }

    WidgetsBinding.instance.rootElement?.visitChildren(findAllElements);

    return widgetPositions;
  }
}

extension ValueKeyExtension on ValueKey<String> {
  bool get isElementKeyFormat {
    // 如果有自定義的判斷函數，使用自定義的邏輯
    if (ElementKeyInspector._customElementKeyFormatChecker != null) {
      return ElementKeyInspector._customElementKeyFormatChecker!(value);
    }

    return true;
  }
}
