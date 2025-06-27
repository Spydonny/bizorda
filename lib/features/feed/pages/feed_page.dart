import 'package:bizorda/features/feed/widgets/post_item.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../data/models/post.dart';
import '../data/repos/post_repo.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final talker = Talker();

  late Future<List<Post>> _futurePosts;
  late final PostRepository postRepository;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final shared = await SharedPreferences.getInstance();
    final token = shared.getString('access_token') ?? '';
    postRepository = PostRepository(token: token);
    setState(() {
      _futurePosts = postRepository.getAllPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController searchController = TextEditingController();

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
          onChanged: (String str) {

          },
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            talker.error(snapshot.error);
            return Center(child: Text('Ошибка в системе'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет постов'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostItem(item: posts[index],
              onLike: (postId) => postRepository.likePost(postId),),
          );
        },
      ),
    );
  }
}

