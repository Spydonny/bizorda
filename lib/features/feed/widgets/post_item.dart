import 'package:bizorda/features/feed/data/models/post.dart';
import 'package:bizorda/features/profile/view/others_company_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.item,
    required this.userId,
    required this.onLike,
    this.onTapProfile,
  });

  final Post item;
  final String userId;
  final Future<Post> Function(String postId, String userId) onLike;
  final VoidCallback? onTapProfile;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late int likes;
  late bool liked;

  @override
  void initState() {
    super.initState();
    likes = widget.item.likes;
    liked = widget.item.idsLiked.contains(widget.userId); // <-- проверяем лайкал ли юзер
  }

  Future<void> _toggleLike() async {
    try {
      final updatedPost = await widget.onLike(widget.item.id, widget.userId);
      setState(() {
        likes = updatedPost.likes;
        liked = updatedPost.idsLiked.contains(widget.userId);
      });
    } catch (e) {
      // можно добавить snackbar/talker
      debugPrint('Ошибка при лайке: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .sizeOf(context)
        .width;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: widget.item.companyName.length * 10.0,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OthersCompanyProfilePage(companyId: widget.item.companyId)
                                      )
                                  ),
                                  child: Text(
                                    widget.item.companyName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ),

                              const SizedBox(width: 4),
                              SizedBox(width: 150,
                                child: Text(
                                  '@${widget.item.senderName}',

                                  style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeago.format(
                                    widget.item.timestamp, locale: 'ru'),
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
                            "https://enterra-api.onrender.com${widget.item
                                .image!}",
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
                            icon: liked ? Icons.favorite : Icons
                                .favorite_border,
                            label: likes.toString(),
                            color: liked ? Colors.red : null,
                            onClick: _toggleLike,
                          ),
                          _PostAction(
                              icon: Icons.chat_bubble_outline, label: '0'),
                          _PostAction(icon: Icons.sync, label: '0'),
                          // _PostAction(icon: Icons.visibility, label: '6'),

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
        const SizedBox(width: 2),
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



