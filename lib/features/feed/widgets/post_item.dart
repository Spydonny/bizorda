import 'package:bizorda/features/feed/data/models/post.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget {
  const PostItem({super.key, required this.item, required this.onLike});
  final Post item;
  final Function(String) onLike;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late int likes;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.item.likes;
  }

  void _toggleLike() {
    setState(() {
      if (liked) {
        likes--;
      } else {
        likes++;
        widget.onLike(widget.item.id);
      }
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: screenWidth * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// company name + sender + timestamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.item.companyName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '@${widget.item.senderName}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeago.format(widget.item.timestamp, locale: 'ru'),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white30),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// post content
                      Text(
                        widget.item.content,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),

                      /// image (optional)
                      if (widget.item.image != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://enterra-api.onrender.com${widget.item.image!}",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      /// action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PostAction(
                            icon: liked ? Icons.favorite : Icons.favorite_border,
                            label: likes.toString(),
                            color: liked ? Colors.red : null,
                            onClick: _toggleLike,
                          ),
                          _PostAction(icon: Icons.chat_bubble_outline, label: '2564'),
                          _PostAction(icon: Icons.sync, label: '2564'),
                          _PostAction(icon: Icons.visibility, label: '2564'),
                          IconButton(
                            onPressed: () {
                              // TODO: bookmark logic
                            },
                            icon: const Icon(Icons.bookmark_border),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.5, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

// Вспомогательный виджет для иконок действий
class _PostAction extends StatelessWidget {
  const _PostAction({required this.icon, required this.label, this.onClick, this.color});
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onClick,
          color: color,
          icon: Icon(icon, size: 15),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white60),
        ),
      ],
    );
  }
}



