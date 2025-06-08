import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Убедись, что у тебя подключён go_router

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({
    super.key,
    required this.chosenIdx,
    required this.onClose,
  });

  final int chosenIdx;
  final VoidCallback onClose;

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        children: List.generate(6, (int idx) {
          final List<IconData> icons = [
            Icons.home_outlined,
            Icons.person_outline,
            Icons.chat_bubble_outline,
            Icons.feed_outlined,
            Icons.description_outlined,
            Icons.settings_outlined,
          ];
          final List<String> titles = [
            'ГЛАВНАЯ',
            'ПРОФИЛЬ',
            'СООБЩЕНИЯ',
            'ЛЕНТА НОВОСТЕЙ',
            'ДОКУМЕНТЫ',
            'НАСТРОЙКИ',
          ];
          final List<String> routes = [
            '/',
            '/profile',
            '/messages',
            '/feed',
            '/docs',
            '/settings'
          ];
          final isChosen = idx == widget.chosenIdx;
          return _buildListTile(context, icons[idx], titles[idx], routes[idx], isChosen);
        }),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String route, bool isChosen) {
    final theme = Theme.of(context);
    return Container(
      width: 130,
      color: isChosen ? theme.colorScheme.onPrimary : theme.colorScheme.secondaryContainer,
      child: ListTile(
        leading: Icon(
          icon,
          color: isChosen ? theme.colorScheme.primary : Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 7,
          ),
        ),
        onTap: () {
          if (!isChosen) {
            widget.onClose();     // Сначала закрываем Overlay
            context.go(route);    // Потом навигируем
          }
        },
      ),
    );
  }
}
