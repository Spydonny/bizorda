import 'package:bizorda/gen/assets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme.dart';
import '../data/models/message.dart';
import '../data/repos/messages_repo.dart';



class ChatScreen extends StatefulWidget {
  final String roomId;
  final String currentUserId; // <-- You must pass this

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late final MessagesRepo _repo;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final shared = await SharedPreferences.getInstance();
    final token = shared.getString('access_token');
    _repo = MessagesRepo(token: token ?? '');

    try {
      final messages = await _repo.getMessages(widget.roomId);
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });

      for (final msg in messages) {
        if (msg.senderId != widget.currentUserId && msg.status != 'read') {
          try {
            await _repo.markMessageRead(
              roomId: widget.roomId,
              messageId: msg.id,
            );
            setState(() {
              final idx = _messages.indexWhere((m) => m.id == msg.id);
              if (idx != -1) {
                _messages[idx] = _messages[idx].copyWith(status: 'read');
              }
            });
          } catch (_) {
            // You might log this or silently ignore it
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки сообщений';
        _isLoading = false;
      });
    }
  }


  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    // Optimistic UI update
    final tempMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      content: text,
      image: null,
      senderId: widget.currentUserId,
      timestamp: DateTime.now(),
      status: 'sending',
    );

    setState(() {
      _messages.add(tempMessage);
    });

    try {
      final sentMessage = await _repo.sendMessage(
        roomId: widget.roomId,
        content: text,
      );
      setState(() {
        final idx = _messages.indexWhere((m) => m.id == tempMessage.id);
        if (idx != -1) _messages[idx] = sentMessage;
      });
    } catch (_) {
      setState(() {
        final idx = _messages.indexWhere((m) => m.id == tempMessage.id);
        if (idx != -1) _messages[idx] =
            tempMessage.copyWith(status: 'failed');
      });
    }
  }

  Future<void> _pickAttachment(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null) return;

    try {
      final sent = await _repo.sendMessage(
        roomId: widget.roomId,
        content: '',
        imageFilePath: file.path,
      );
      setState(() => _messages.add(sent));
    } catch (_) {
      // handle error
    }
  }

  void _showAttachOptions(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: () {
                Navigator.pop(ctx);
                _pickAttachment(ImageSource.gallery);
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.pop(ctx);
                _pickAttachment(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чат')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final msg = _messages[i];
                return _ChatBubble(
                  message: msg.content,
                  time: msg.timestamp,
                  isMe: msg.senderId == widget.currentUserId,
                  status: msg.status,
                );
              },
            ),
          ),
          _InputBar(
            controller: _controller,
            onSend: _sendText,
            onAttach: () => _showAttachOptions(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


/// Отображение сообщения
class _ChatBubble extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isMe;
  final String status;

  const _ChatBubble({
    required this.message,
    required this.time,
    required this.isMe,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isMe ? AppColors.bubbleMe : AppColors.bubbleOther,
              borderRadius: isMe
                  ? const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(33),
              )
                  : const BorderRadius.only(
                topLeft: Radius.circular(33),
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe) const SizedBox(width: 8),
                Text(message),
                if (isMe) const SizedBox(width: 8),
                if (isMe) _CheckMark(status: status),
              ],
            ),
          ),
          Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  final String status;

  const _CheckMark({required this.status});

  @override
  Widget build(BuildContext context) {
    String asset;
    if(status == 'read'){
      asset = AppAssets.messageRead;
    } else {
      asset = AppAssets.messageSend;
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Image.asset(asset, scale: 5),
      ],
    );
  }
}


/// Поле ввода
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const _InputBar({required this.controller, required this.onSend, required this.onAttach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(onPressed: onAttach, icon: const Icon(Icons.attach_file)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'напишите что-нибудь...',
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
