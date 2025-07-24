import 'package:flutter/material.dart';


class ProfileTabSwitcher extends StatelessWidget {
  const ProfileTabSwitcher({super.key, required this.selectedIndex});
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final tabs = ['О компании', 'Публикации', 'Отзывы'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,

        builder: (context, idx, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(tabs.length, (i) {

            final isSelected = i == idx;
            return GestureDetector(
              onTap: () => selectedIndex.value = i,
              child: _buildAnimatedContainer(tabs[i], isSelected)
            );
          }),
        ),
      ),
    );
  }

  AnimatedContainer _buildAnimatedContainer(String tab, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white12 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tab,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
