import 'package:bizorda/features/shared/data/repos/user_repo.dart';
import 'package:bizorda/token_notifier.dart';
import 'package:bizorda/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:talker/talker.dart';

import '../../shared/data/models/user.dart';
import '../data/models/message.dart';
import '../data/models/message_room.dart';
import '../data/repos/messages_repo.dart';
import 'chat_screen.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key, required this.user, required this.token});
  final User user;
  final String token;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final talker = Talker();

  late final MessagesRepo _repo = MessagesRepo(token: widget.token);
  late final UsersRepo _usersRepo = UsersRepo(token: widget.token);
  late final String _currentUserId = widget.user.id;

  List<MessageRoom> _allRooms = [];
  List<User> _searchResults = [];
  List<MessageRoom> _rooms = [];
  final _lastMessages = <String, Message>{};
  final _unreadCounts = <String, int>{};
  final _chatNames = <String, String>{};
  final _searchController = TextEditingController();

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repo.getRooms();

      for (final room in rooms) {
        final messages = await _repo.getMessages(room.id);

        _lastMessages[room.id] = messages.isNotEmpty
            ? messages.last
            : _emptyMessage();

        _unreadCounts[room.id] = messages
            .where((m) => m.status != 'read' && m.senderId != _currentUserId)
            .length;

        _chatNames[room.id] = await _resolveChatName(room);
      }

      setState(() {
        _allRooms = rooms;
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

  Message _emptyMessage() => Message(
    id: '',
    content: '',
    senderId: '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
    status: 'read',
  );

  Future<String> _resolveChatName(MessageRoom room) async {
    if (!room.isGroup) {
      final otherId = room.participants.firstWhere((id) => id != _currentUserId);
      final user = await _usersRepo.getUserById(otherId);
      return user.fullname;
    }
    return room.name ?? 'Чат';
  }

  void _onSearchChanged(String query) async {
    debugPrint('🔍 Search query: "$query"');
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _rooms = _allRooms;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();

    // Фильтрация существующих чатов
    final filteredRooms = _allRooms.where((room) {
      final name = _chatNames[room.id] ?? '';
      return name.toLowerCase().contains(lowerQuery);
    }).toList();
    debugPrint('✔️ Filtered rooms count: ${filteredRooms.length}');

    List<User> foundUsers = [];
    try {
      foundUsers = await _usersRepo.searchUser(query);
      debugPrint('👤 Found users count: ${foundUsers.length}');
    } catch(e) {
      debugPrint(e.toString());
    }

    // Исключаем тех, с кем чат уже есть
    final participantIds = _allRooms
        .where((r) => !r.isGroup)
        .map((r) => r.participants.firstWhere((id) => id != _currentUserId, orElse: () => ''))
        .toSet();
    final usersWithoutChat = foundUsers
        .where((u) => u.id != _currentUserId && !participantIds.contains(u.id))
        .toList();
    debugPrint('➕ New users without chat: ${usersWithoutChat.length}');

    setState(() {
      _rooms = filteredRooms;
      _searchResults = usersWithoutChat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const NavigationButton(chosenIdx: 2),
        title: const Text('СООБЩЕНИЯ', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          _buildSearchField(theme),
          Expanded(child: _buildContent(theme)),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Поиск чатов',
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
        ),
        controller: _searchController,
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _onError(_error!);

    final hasQuery = _searchController.text.isNotEmpty;
    final hasUserResults = _searchResults.isNotEmpty;

    if (!hasQuery) {
      // просто список чатов
      return ListView(children: _buildChatListTiles(theme));
    }

    if (!hasUserResults) {
      // есть запрос, но ни пользователей, ни (показываем фильтрованные) чаты
      return ListView(
        children: [
          const Center(child: Text('Ничего не найдено')),
          const Divider(),
          ..._buildChatListTiles(theme),
        ],
      );
    }

    // есть и пользователи, и чаты
    return ListView(
      children: [
        // сначала — новые пользователи, с которыми у вас ещё нет чата
        ..._buildSearchResultsTiles(),
        const Divider(), // опционально разделитель
        // затем — уже существующие чаты, отфильтрованные по запросу
        ..._buildChatListTiles(theme),
      ],
    );
  }


  List<ListTile> _buildSearchResultsTiles() {
    return _searchResults.map((user) {
      return ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.fullname),
        trailing: const Icon(Icons.chat),
        onTap: () async {
          final room = await _repo.createRoom(
            isGroup: false,
            participants: [user.id, _currentUserId],
          );
          _openChat(room.id, 'Чат');
        },
      );
    }).toList();
  }


  List<ListTile> _buildChatListTiles(ThemeData theme) {
    return _rooms.map((room) {
      final lastMsg = _lastMessages[room.id];
      final unread = _unreadCounts[room.id] ?? 0;
      final name = _chatNames[room.id] ?? 'Чат';

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.disabledColor,
          child: Icon(Icons.chat, color: theme.iconTheme.color),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          lastMsg?.content.isNotEmpty == true ? lastMsg!.content : 'Нет сообщений',
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastMsg != null ? _formatTime(lastMsg.timestamp) : '',
              style: theme.textTheme.bodySmall,
            ),
            if (unread > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
        onTap: () => _openChat(room.id, name),
      );
    }).toList();
  }

  void _openChat(String roomId, String chatName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          token: tokenNotifier.value,
          roomId: roomId,
          currentUserId: _currentUserId,
          name: chatName,
        ),
      ),
    );
    _loadRooms();
  }

  Widget _onError(String error) {
    talker.error(error);
    return Center(child: Text(error));
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}


