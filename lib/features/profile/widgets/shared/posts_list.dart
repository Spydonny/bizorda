import 'package:bizorda/features/profile/widgets/company/label_local.dart';
import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../../../feed/data/models/post.dart';

class PostsList extends StatelessWidget {
  const PostsList({super.key, required this.posts, this.onAdd});

  final List<Post> posts;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .colorScheme
          .primaryContainer,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelLocal('Мои посты'),
              onAdd != null ? IconButton(
                icon: const Icon(Icons.add, size: 30),
                onPressed: onAdd,
              ) : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) => _PostCard(post: posts[index]),
              )
          )
        ],
      ),
    );
  }
}



class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(backgroundColor: Colors.grey),
            title: Text(
              post.companyName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.senderName,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          if (post.image != null && post.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://enterra-api-production.up.railway.app${post.image!}',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.black12,
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.image, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _IconWithText(icon: Icons.favorite_border, text: '${post.likes}'),
              const _IconWithText(icon: Icons.comment, text: '58'),
              const _IconWithText(icon: Icons.share, text: '5'),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconWithText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}
