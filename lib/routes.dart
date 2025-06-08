import 'package:bizorda/features/feed/feed_page.dart';
import 'package:bizorda/features/messages/messages_page.dart';
import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget _tempPage(int idx) {
   return Scaffold(
     appBar: AppBar(leading: NavigationButton(chosenIdx: idx),),
   );
}

final GoRouter router = GoRouter(
  routes: [
    ...List.generate(6, (int idx) {
      final pageRoutes = [
        '/',
        '/profile',
        '/asa',
        '/assss',
        '/docs',
        '/settings'
      ];

      return GoRoute(
        path: pageRoutes[idx],
        builder: (context, state) => _tempPage(idx),
      );
    }),
    GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesPage()
    ),
    GoRoute(path: '/feed',
      builder: (context, state) => const FeedPage()
    )
  ],
);
