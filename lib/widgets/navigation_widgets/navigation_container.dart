import 'package:bizorda/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Убедись, что у тебя подключён go_router

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
  late SharedPreferences _prefs;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.appBar,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(6, (int idx) {
          final List<IconData> icons = [
            Icons.home_outlined,
            Icons.person_outline,
            Icons.chat_bubble_outline,
            Icons.feed_outlined,
            Icons.settings_outlined,
          ];
          final List<String> titles = [
            'ГЛАВНАЯ',
            'ПРОФИЛЬ',
            'СООБЩЕНИЯ',
            'ЛЕНТА НОВОСТЕЙ',
            'НАСТРОЙКИ',
          ];
          final List<String> routes = [
            '/',
            '/profile',
            '/messages',
            '/feed',
            '/settings'
          ];
          final isChosen = idx == widget.chosenIdx;
          return _buildListTile(context, icons[idx], titles[idx], routes[idx], isChosen);
        }),
          ElevatedButton(onPressed: () {
            setState(() {
              _prefs.remove('access_token');
              context.go('/login');
            });
          }, child: Text('Выйти'))
      ]
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String route, bool isChosen) {
    final theme = Theme.of(context);
    return Container(
      width: 130,
      color: isChosen ? Colors.white24 : Colors.transparent,
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
