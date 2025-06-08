import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';

/// Экран фида
class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<FeedItem> _items = [
    FeedItem(
      avatarUrl: null,
      title: 'HG Group',
      tags: ['AI', 'architecture', '3dmodeling', 'visualisation'],
      timeLabel: '1 ч. назад',
      contentText: 'well finished interior for multiple uses\n- lighting, materials and textures included\n- light is files',
      imageUrl: null,
    ),
    FeedItem(
      avatarUrl: null,
      title: 'Mercedes',
      tags: ['реклама', 'авто'],
      timeLabel: '2 дн. назад',
      contentText: 'Mercedes — создан, чтобы покорять!',
      imageUrl: 'https://max-cars.ru/wp-content/uploads/2023/07/клэ-1-1024x683.jpg',
    ),
    FeedItem(
      avatarUrl: null,
      title: 'FR13NDS TEAM',
      tags: ['реклама', 'найм'],
      timeLabel: '1 дн. назад',
      contentText: 'НАЙМ ИГРОКОВ В КОМАНДУ!!!\nНаша академическая команда DOCSTAR ...',
      imageUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: NavigationButton(chosenIdx: 3),
        title: TextField(
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'напишите что-нибудь...',
            hintStyle: theme.textTheme.bodyMedium,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            contentPadding: theme.inputDecorationTheme.contentPadding,
            border: theme.inputDecorationTheme.border,
            prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'ВСЕ'),
              Tab(text: 'ПОПУЛЯРНОЕ'),
              Tab(text: 'НОВОЕ'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                3,
                    (_) => ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _items.length,
                  itemBuilder: (context, index) => FeedCard(item: _items[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Модель элемента фида
class FeedItem {
  final String? avatarUrl;
  final String title;
  final List<String> tags;
  final String timeLabel;
  final String contentText;
  final String? imageUrl;

  FeedItem({
    this.avatarUrl,
    required this.title,
    required this.tags,
    required this.timeLabel,
    required this.contentText,
    this.imageUrl,
  });
}

/// Виджет карточки фида
class FeedCard extends StatelessWidget {
  final FeedItem item;
  const FeedCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.avatarUrl != null
                  ? CircleAvatar(backgroundImage: NetworkImage(item.avatarUrl!))
                  : const CircleAvatar(backgroundColor: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: -8,
                      children: item.tags
                          .map((tag) => Text('#$tag', style: theme.textTheme.bodyMedium))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Text(item.timeLabel, style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.contentText, style: theme.textTheme.bodyLarge),
          if (item.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.imageUrl!, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
              IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
              IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
              IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
