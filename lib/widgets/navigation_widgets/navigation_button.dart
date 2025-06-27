import 'package:flutter/material.dart';

import 'navigation_container.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton({super.key, required this.chosenIdx, this.isLoading=false});
  final int chosenIdx;
  final bool isLoading;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  bool isClosed = true;

  void _toggleMenu() {
    if (!isClosed) return;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Полупрозрачный фон, чтобы закрывать по тапу вне меню
          GestureDetector(
            onTap: () {
              entry.remove();
              setState(() => isClosed = true);
            },
            child: Container(
              color: Colors.black54,
            ),
          ),
          Positioned(
            left: 10,
            top: 50,
            child: Material(
              elevation: 10,
              child: NavigationContainer(
                chosenIdx: widget.chosenIdx,
                onClose: () {
                  entry.remove();
                  setState(() => isClosed = true);
                },
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
    setState(() => isClosed = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isLoading ? () {} :  _toggleMenu,
      icon:  Icon(isClosed ? Icons.menu : Icons.close),
      color: Colors.white,
      tooltip: isClosed ? 'Открыть меню' : 'Закрыть меню',
    );
  }
}