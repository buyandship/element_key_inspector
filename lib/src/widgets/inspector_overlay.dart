import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screen.dart';

class InspectorOverlay extends StatefulWidget {
  final Map<String, Rect> widgetPositions;
  final VoidCallback? onClose;

  const InspectorOverlay({
    super.key,
    required this.widgetPositions,
    this.onClose,
  });

  @override
  State<InspectorOverlay> createState() => _InspectorOverlayState();
}

class _InspectorOverlayState extends State<InspectorOverlay> {
  bool isExpanded = true;
  double sectionHeight = screenHeight / 4;
  late ValueNotifier<int?> selectedElementKeyIndexNotifier;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.lime,
    Colors.indigo,
    Colors.amber,
    Colors.brown,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    selectedElementKeyIndexNotifier = ValueNotifier<int?>(null);
  }

  @override
  void dispose() {
    selectedElementKeyIndexNotifier.dispose();
    super.dispose();
  }

  void togglePanel() {
    setState(() {
      isExpanded = !isExpanded;
      sectionHeight = isExpanded ? screenHeight / 4 : 50;
    });
  }

  Widget _buildElementKeyButtons({required Map<String, Rect> widgetPositions}) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<int?>(
              valueListenable: selectedElementKeyIndexNotifier,
              builder: (context, selectedIndex, child) {
                return Wrap(
                  children: widgetPositions.entries.mapIndexed((index, entry) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors[index % colors.length], width: 3),
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          color: selectedIndex == index ? colors[index % colors.length].withOpacity(0.3) : Colors.transparent,
                        ),
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        selectedElementKeyIndexNotifier.value = index;
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        // Highlight Element Key Position
        ValueListenableBuilder<int?>(
          valueListenable: selectedElementKeyIndexNotifier,
          builder: (context, selectedIndex, child) {
            return Stack(
              children: [
                ...widget.widgetPositions.entries.mapIndexed(
                  (index, entry) {
                    if (selectedIndex != null && selectedIndex != index) {
                      return null;
                    }

                    final Rect rect = entry.value;
                    final Color color = colors[index % colors.length];

                    return Positioned(
                      top: rect.top,
                      left: rect.left,
                      child: Container(
                        width: rect.width,
                        height: rect.height,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.5),
                          border: Border.all(
                            color: color,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ).whereType(),
              ],
            );
          },
        ),
        // Element Key Panel
        Positioned.fill(
          top: screenHeight - sectionHeight,
          child: Material(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                GestureDetector(
                  onTap: togglePanel,
                  child: Container(
                    height: 32,
                    color: Colors.white.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: FaIcon(isExpanded ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronDown, color: Colors.white, size: 20),
                      onPressed: togglePanel,
                    ),
                  ),
                ),
                if (isExpanded) _buildElementKeyButtons(widgetPositions: widget.widgetPositions),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension Iterables<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
