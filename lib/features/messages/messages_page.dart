import 'package:bizorda/features/messages/chat_screen.dart';
import 'package:bizorda/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // TODO: связать с бэком
  final List<_MessageItem> _messages = [
    _MessageItem(
      title: 'Поддержка',
      subtitle: 'Вы: Баг на главном интерфейсе',
      time: '20:33',
      unreadCount: 0,
      hasAudio: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // Используем цвет из темы
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: const NavigationButton(chosenIdx: 2),
        title: const Text(
          'СООБЩЕНИЯ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Поиск сообщений',
                // Используем цвета из темы InputDecoration
                hintStyle: theme.textTheme.bodyMedium,
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                contentPadding: theme.inputDecorationTheme.contentPadding,
                border: theme.inputDecorationTheme.border,
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              ),
              onChanged: (query) {
                // TODO: Implement search logic
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _messages.length,
              separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: msg.hasAudio
                      ? Icon(Icons.mic, color: theme.iconTheme.color)
                      : CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.disabledColor,
                  ),
                  title: Text(
                    msg.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: msg.subtitle != null
                      ? Text(
                    msg.subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  )
                      : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        msg.time,
                        style: theme.textTheme.bodySmall,
                      ),
                      if (msg.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.unreadCount.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageItem {
  final String title;
  final String? subtitle;
  final String time;
  final int unreadCount;
  final bool hasAudio;

  _MessageItem({
    required this.title,
    this.subtitle,
    required this.time,
    required this.unreadCount,
    required this.hasAudio,
  });
}

