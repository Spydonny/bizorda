import 'package:bizorda/features/feed/widgets/post_item.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:talker/talker.dart';

import '../data/models/post.dart';
import '../data/repos/post_repo.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.token});
  final String token;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final talker = Talker();

  final TextEditingController searchController = TextEditingController();

  List<Post> _posts = [];
  List<Post> _allPosts = [];
  late final PostRepository postRepository;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    postRepository = PostRepository(token: widget.token);
    try {
      final posts = await postRepository.getAllPosts();
      setState(() {
        _allPosts = posts;
        _posts = posts;
        _isLoading = false;
      });
    } catch (e, st) {
      talker.error('Ошибка при загрузке постов: $e', st);
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onSearchChanged(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = _allPosts.where((post) {
      return post.content.toLowerCase().contains(lowerQuery) ||
          post.senderName.toLowerCase().contains(lowerQuery) ||
          post.companyName.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _posts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: NavigationButton(chosenIdx: 3),
        title: TextField(
          style: theme.textTheme.bodyLarge,
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'напишите что-нибудь...',
            hintStyle: theme.textTheme.bodyMedium,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            contentPadding: theme.inputDecorationTheme.contentPadding,
            border: theme.inputDecorationTheme.border,
            prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('Ошибка в системе'))
          : _posts.isEmpty
          ? const Center(child: Text('Нет постов'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) => PostItem(
          item: _posts[index],
          onLike: (postId) => postRepository.likePost(postId),

        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}


