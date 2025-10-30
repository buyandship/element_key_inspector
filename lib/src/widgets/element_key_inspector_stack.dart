import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../element_key_inspector.dart';
import '../screen.dart';

import 'inspector_overlay.dart';

/// A widget that wraps your app content and provides an inspector overlay
/// for visualizing element keys in the widget tree.
///
/// This widget displays your app normally and optionally shows a floating
/// action button that toggles an overlay displaying all element keys found
/// within the initialized [ElementKeyScope]s.
///
/// Example:
/// ```dart
/// ElementKeyInspectorStack(
///   isShowInspectButton: true,
///   child: MyApp(),
/// )
/// ```
class ElementKeyInspectorStack extends StatefulWidget {
  /// The child widget to wrap (typically your app's root widget).
  final Widget child;

  /// Whether to show the floating inspect button.
  final bool isShowInspectButton;

  /// Optional custom inspect button widget to use instead of the default.
  final Widget? inspectButton;

  /// Optional initial position for the inspect button.
  final Offset? inspectButtonPosition;

  /// Creates an [ElementKeyInspectorStack].
  const ElementKeyInspectorStack({
    super.key,
    required this.child,
    this.isShowInspectButton = false,
    this.inspectButton,
    this.inspectButtonPosition,
  });

  @override
  State<ElementKeyInspectorStack> createState() =>
      _ElementKeyInspectorStackState();
}

class _ElementKeyInspectorStackState extends State<ElementKeyInspectorStack> {
  late ValueNotifier<Offset> buttonPositionNotifier;
  late Size screenSize;
  final fabSize = 56.0;
  bool isShowInspectorOverlay = false;

  @override
  void initState() {
    super.initState();
    buttonPositionNotifier = ValueNotifier(widget.inspectButtonPosition ??
        Offset(screenWidth - 68, screenHeight * 0.6));
  }

  @override
  void dispose() {
    buttonPositionNotifier.dispose();
    super.dispose();
  }

  Widget _buildDefaultInspectButton() {
    return Theme(
      data: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
        ),
      ),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            isShowInspectorOverlay = !isShowInspectorOverlay;
          });
        },
        child: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        widget.child,
        if (isShowInspectorOverlay)
          InspectorOverlay(
            widgetPositions: ElementKeyInspector.getElementKeyPositions(),
            onClose: () {
              setState(() {
                isShowInspectorOverlay = false;
              });
            },
          ),
        if (widget.isShowInspectButton)
          ValueListenableBuilder<Offset>(
            valueListenable: buttonPositionNotifier,
            builder: (context, buttonPosition, child) {
              return Positioned(
                left: buttonPosition.dx,
                top: buttonPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    double newX = buttonPosition.dx + details.delta.dx;
                    double newY = buttonPosition.dy + details.delta.dy;

                    // limit the button in the screen range
                    newX = newX.clamp(0.0, screenSize.width - fabSize);
                    newY = newY.clamp(0.0, screenSize.height - fabSize);

                    buttonPositionNotifier.value = Offset(newX, newY);
                  },
                  child: widget.inspectButton ?? _buildDefaultInspectButton(),
                ),
              );
            },
          ),
      ],
    );
  }
}
