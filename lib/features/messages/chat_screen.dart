import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme.dart';

class Message {
  final String text;
  final bool isMe;
  final DateTime time;
  Message({required this.text, required this.isMe, required this.time});
}


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: text, isMe: true, time: DateTime.now()));
    });
    _controller.clear();
    _simulateReply();
  }

  void _simulateReply() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message(
          text: 'Ответ поддержки на "${_messages.last.text}"',
          isMe: false,
          time: DateTime.now(),
        ));
      });
    });
  }

  Future<void> _pickAttachment(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null) return;
    setState(() {
      _messages.add(Message(
        text: 'Прикреплен файл: ${file.name}',
        isMe: true,
        time: DateTime.now(),
      ));
    });
    // TODO: загрузить файл
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
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: () {
                Navigator.pop(ctx);
                // TODO: добавить вставку ссылки
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
      appBar: AppBar(
        title: const Text('Поддержка'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final msg = _messages[i];
                return _ChatBubble(
                  message: msg.text,
                  time: msg.time,
                  isMe: msg.isMe,
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
  const _ChatBubble({required this.message, required this.time, required this.isMe});

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
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message),
          ),
          Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
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
