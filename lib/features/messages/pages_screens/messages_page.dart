import 'package:bizorda/features/shared/data/repos/user_repo.dart';
import 'package:bizorda/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/data/models/user.dart';
import '../data/models/message.dart';
import '../data/models/message_room.dart';
import '../data/repos/messages_repo.dart';
import 'chat_screen.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key, required this.user});
  final User user;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final MessagesRepo _repo;
  late final UsersRepo _usersRepo;
  late final _currentUserId = widget.user.id;

  List<MessageRoom> _rooms = [];
  final Map<String, Message> _lastMessages = {};
  final Map<String, int> _unreadCounts = {};
  final Map<String, String> _chatNames = {}; // ✅ NEW

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final shared = await SharedPreferences.getInstance();
    final token = shared.getString('access_token');
    _repo = MessagesRepo(token: token ?? '');
    _usersRepo = UsersRepo(token: token ?? '');
    await _repo.createRoom(isGroup: false, participants: ['afb89fe7-7df2-497d-bff7-99f1ac76b220', _currentUserId]);
    await _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repo.getRooms();

      for (final room in rooms) {
        final messages = await _repo.getMessages(room.id);

        // ✅ Store last message and unread count
        if (messages.isNotEmpty) {
          _lastMessages[room.id] = messages.last;
          _unreadCounts[room.id] = messages
              .where((m) =>
          m.status != 'read' && m.senderId != _currentUserId)
              .length;
        } else {
          _lastMessages[room.id] = Message(
            id: '',
            content: '',
            senderId: '',
            timestamp: DateTime.fromMillisecondsSinceEpoch(0),
            status: 'read',
          );
          _unreadCounts[room.id] = 0;
        }

        // ✅ Store chat name
        _chatNames[room.id] = await chatName(room);
      }

      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                hintText: 'Поиск чатов',
                hintStyle: theme.textTheme.bodyMedium,
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                contentPadding: theme.inputDecorationTheme.contentPadding,
                border: theme.inputDecorationTheme.border,
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              ),
              onChanged: (query) {
                // TODO: Add search logic
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text('Ошибка: $_error'))
                : ListView.separated(
              itemCount: _rooms.length,
              separatorBuilder: (_, __) =>
                  Divider(color: theme.dividerColor),
              itemBuilder: (context, index) {
                final room = _rooms[index];
                final lastMsg = _lastMessages[room.id];
                final unread = _unreadCounts[room.id] ?? 0;
                final name = _chatNames[room.id] ?? 'Чат';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.disabledColor,
                    child: Icon(Icons.chat, color: theme.iconTheme.color),
                  ),
                  title: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    lastMsg?.content.isNotEmpty == true
                        ? lastMsg!.content
                        : 'Нет сообщений',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lastMsg != null
                            ? formatTime(lastMsg.timestamp)
                            : '',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (unread > 0)
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
                            unread.toString(),
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
                        builder: (_) => ChatScreen(
                          roomId: room.id,
                          currentUserId: _currentUserId,
                        ),
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

  Future<String> chatName(MessageRoom room) async {
    if (!room.isGroup) {
      final tempID = room.participants[0] != _currentUserId
          ? room.participants[0]
          : room.participants[1];
      final User user = await _usersRepo.getUserById(tempID);
      return user.fullname;
    }
    return room.name ?? 'Чат';
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}


