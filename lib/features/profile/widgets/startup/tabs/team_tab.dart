import 'package:flutter/material.dart';

class TeamTab extends StatelessWidget {
  const TeamTab({super.key, required this.cards, this.onAdd, required this.isLoading});

  final List<Widget> cards;
  final VoidCallback? onAdd;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final separatedCards = cards
        .expand((widget) => [widget, const Divider(thickness: 1.5)])
        .toList();

    if (separatedCards.isNotEmpty) {
      separatedCards.removeLast();
    }
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (cards.isEmpty) {
      return const Center(child: Text('Команда не добавлена'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: onAdd == null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                const Text('Команда проекта'),
                if (onAdd != null)
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...separatedCards,
          ],
        ),
      ),
    );
  }
}

